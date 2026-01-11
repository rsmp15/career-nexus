import pandas as pd
import numpy as np
import pickle
import os
# Lazy imports for heavy libraries
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class JobVectorStore:
    def __init__(self, jobs_df: pd.DataFrame, gemini_service, cache_path="job_embeddings.pkl"):
        self.jobs_df = jobs_df
        self.cache_path = cache_path
        self.gemini_service = gemini_service
        self.is_ready = False
        self.embeddings = None
        
        # Start background initialization
        import threading
        self.init_thread = threading.Thread(target=self._initialize_embeddings_background)
        self.init_thread.daemon = True # Daemon thread so it doesn't block shutdown
        self.init_thread.start()

    def _initialize_embeddings_background(self):
        """
        Runs in a background thread to load or compute embeddings.
        """
        logger.info("Background initialization of JobVectorStore started...")
        
        # 1. Try Load
        if os.path.exists(self.cache_path):
            try:
                with open(self.cache_path, 'rb') as f:
                    self.embeddings = pickle.load(f)
                    self.is_ready = True
                    logger.info("✅ Loaded cached embeddings. Vector Store is READY.")
                    return
            except Exception as e:
                logger.warning(f"Failed to load cache: {e}")
        
        # 2. Compute if not loaded
        logger.info("Computing embeddings via Gemini API (Background Process)...")
        
        texts = (
            "Title: " + self.jobs_df['Title'].astype(str) + 
            "; Description: " + self.jobs_df['Description'].astype(str)
        ).tolist()
        
        embeddings = []
        import time
        
        for i, text in enumerate(texts):
            if i % 10 == 0: logger.info(f"Embedded {i}/{len(texts)} jobs...")
            
            try:
                emb = self.gemini_service.get_embedding(text)
                if emb:
                    embeddings.append(emb)
                else:
                    embeddings.append([0.0] * 768)
            except Exception as e:
                logger.error(f"Error embedding job {i}: {e}")
                embeddings.append([0.0] * 768)
                
            time.sleep(0.5) # Gentler rate limit for background task
            
        self.embeddings = np.array(embeddings)
        self.is_ready = True
        logger.info("✅ Computed and stored embeddings. Vector Store is READY.")
        
        # 3. Save
        try:
            with open(self.cache_path, 'wb') as f:
                pickle.dump(self.embeddings, f)
        except Exception as e:
            logger.warning(f"Could not save cache: {e}")

    def search(self, query: str, top_k: int = 50) -> list[dict]:
        """
        Returns a list of dicts: {'index': int, 'score': float}
        """
        if not self.is_ready or self.embeddings is None:
             logger.warning("Vector Store NOT ready. Returning empty results (Fallback).")
             return []
             
        query_embedding = self.gemini_service.get_embedding(query)
        if not query_embedding:
            return []
            
        query_embedding = np.array([query_embedding])
        
        # Cosine Similarity
        from sklearn.metrics.pairwise import cosine_similarity
        
        # Ensure dimensions match
        if query_embedding.shape[1] != self.embeddings.shape[1]:
             logger.error("Dimension mismatch between query and database!")
             return []

        scores = cosine_similarity(query_embedding, self.embeddings)[0]
        
        # Get top K indices
        top_indices = np.argsort(scores)[::-1][:top_k]
        
        results = []
        for idx in top_indices:
            results.append({
                "index": idx,
                "score": float(scores[idx])
            })
            
        return results
