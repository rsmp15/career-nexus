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
        self.embeddings = self._load_or_compute_embeddings()

    def _load_or_compute_embeddings(self):
        if os.path.exists(self.cache_path):
            try:
                with open(self.cache_path, 'rb') as f:
                    logger.info("Loading cached embeddings...")
                    return pickle.load(f)
            except Exception as e:
                logger.warning(f"Failed to load cache: {e}")
        
        logger.info("Computing embeddings via Gemini API (this WILL take time due to rate limits)...")
        
        texts = (
            "Title: " + self.jobs_df['Title'].astype(str) + 
            "; Description: " + self.jobs_df['Description'].astype(str)
        ).tolist()
        
        embeddings = []
        # Process in batches or one by one with rate limiting? 
        # For simplicity and robust free tier usage, one by one is safer but slow.
        # Let's try to do it in a loop.
        import time
        
        for i, text in enumerate(texts):
            if i % 10 == 0: logger.info(f"Embedded {i}/{len(texts)} jobs...")
            emb = self.gemini_service.get_embedding(text)
            if emb:
                embeddings.append(emb)
            else:
                # If fail, verify length. If catastrophic failure, we might end up with empty list.
                # Fallback to zero vector?
                embeddings.append([0.0] * 768) # Assuming 768 dim
            time.sleep(0.2) # Rate limit protection
            
        embeddings = np.array(embeddings)
        
        try:
            with open(self.cache_path, 'wb') as f:
                pickle.dump(embeddings, f)
        except Exception as e:
            logger.warning(f"Could not save cache: {e}")
            
        return embeddings

    def search(self, query: str, top_k: int = 50) -> list[dict]:
        """
        Returns a list of dicts: {'index': int, 'score': float}
        """
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
