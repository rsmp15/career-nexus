import os
import pandas as pd
import pickle
import numpy as np
import time
from dotenv import load_dotenv

# Setup Environment
# Setup Environment
load_dotenv(os.path.join(os.path.dirname(__file__), '.env'))

# Imports from existing modules
# We need to hack the path a bit if running as script
import sys
sys.path.append(os.path.dirname(__file__))

from gemini_service import GeminiService

DATA_PATH = os.path.join(os.path.dirname(__file__), "data", "Occupation Data.txt")
CACHE_PATH = os.path.join(os.path.dirname(__file__), "job_embeddings.pkl")

def build():
    print("--- 🏗️  Building Embeddings for Production ---")
    
    if not os.path.exists(DATA_PATH):
        print(f"❌ Data file not found at: {DATA_PATH}")
        return

    print("Loading data...")
    df = pd.read_csv(DATA_PATH, sep="\t")
    print(f"Loaded {len(df)} jobs.")
    
    print("Initializing Gemini Service...")
    gemini = GeminiService()
    if not gemini.is_configured:
        print("❌ Gemini Service NOT configured. Check GEMINI_API_KEY.")
        return

    texts = (
        "Title: " + df['Title'].astype(str) + 
        "; Description: " + df['Description'].astype(str)
    ).tolist()
    
    embeddings = []
    print(f"Starting embedding generation for {len(texts)} items...")
    print("Estimated time: ~5-10 minutes.")
    
    for i, text in enumerate(texts):
        if i % 20 == 0: 
            print(f"Processed {i}/{len(texts)}...")
        
        try:
            emb = gemini.get_embedding(text)
            if emb:
                embeddings.append(emb)
            else:
                print(f"⚠️ Empty embedding for index {i}")
                embeddings.append([0.0] * 768)
        except Exception as e:
            print(f"❌ Error at index {i}: {e}")
            embeddings.append([0.0] * 768)
        
        # Rate limit handling
        time.sleep(0.3)

    embeddings = np.array(embeddings)
    print(f"✅ Finished. Shape: {embeddings.shape}")
    
    print(f"Saving to {CACHE_PATH}...")
    with open(CACHE_PATH, 'wb') as f:
        pickle.dump(embeddings, f)
        
    print("🎉 Done! Commit 'job_embeddings.pkl' to the repo for instant startup.")

if __name__ == "__main__":
    build()
