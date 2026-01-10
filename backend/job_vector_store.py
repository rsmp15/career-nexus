import pandas as pd
import numpy as np
import pickle
import os
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class JobVectorStore:
    def __init__(self, jobs_df: pd.DataFrame, cache_path="job_embeddings.pkl"):
        self.jobs_df = jobs_df
        self.cache_path = cache_path
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
        self.embeddings = self._load_or_compute_embeddings()

    def _load_or_compute_embeddings(self):
        if os.path.exists(self.cache_path):
            try:
                with open(self.cache_path, 'rb') as f:
                    logger.info("Loading cached embeddings...")
                    return pickle.load(f)
            except Exception as e:
                logger.warning(f"Failed to load cache: {e}")
        
        logger.info("Computing embeddings (this may take a moment)...")
        # Combine title and description for semantic richness
        # Weight title more heavy by repeating it? Or just sticking to "Title: ... Desc: ..." format
        texts = (
            "Title: " + self.jobs_df['Title'].astype(str) + 
            "; Description: " + self.jobs_df['Description'].astype(str)
        ).tolist()
        
        embeddings = self.model.encode(texts, show_progress_bar=True)
        
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
        query_embedding = self.model.encode([query])
        
        # Cosine Similarity
        # query_embedding is (1, 384), embeddings is (N, 384)
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
