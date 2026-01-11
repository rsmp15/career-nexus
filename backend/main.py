from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import pandas as pd
import json
import os
import re
from dotenv import load_dotenv

# Load env vars immediately
load_dotenv(os.path.join(os.path.dirname(__file__), '.env'))

app = FastAPI(title="CareerNexus AI Backend", version="1.0.0")

# --- CORS Middleware ---
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=False,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# --- Data Loading ---
DATA_PATH = os.path.join(os.path.dirname(__file__), "data", "Occupation Data.txt")

# Global variable to hold dataframe
jobs_df = None

def load_data():
    global jobs_df
    try:
        # Assuming tab-separated or compatible format based on file view
        # The file viewed had "O*NET-SOC Code\tTitle\tDescription" 
        jobs_df = pd.read_csv(DATA_PATH, sep="\t")
        print(f"Loaded {len(jobs_df)} jobs.")
    except Exception as e:
        print(f"Error loading data: {e}")
        jobs_df = pd.DataFrame() # Fallback

@app.on_event("startup")
async def startup_event():
    print("--- Startup Event Triggered ---")
    load_data()

@app.get("/")
def read_root():
    return {"message": "CareerNexus AI Backend is Running (Async Mode)."}

@app.get("/health")
def health_check():
    ai_status = False
    message = "AI functionality is warming up. Basic rule-based matching is active."
    
    if job_matcher and hasattr(job_matcher, 'vector_store') and job_matcher.vector_store.is_ready:
        ai_status = True
        message = "System Fully Operational (AI Ready)."
        
    return {
        "status": "healthy",
        "ai_ready": ai_status,
        "message": message
    }

# --- Pydantic Models for Input ---

class UserProfile(BaseModel):
    life_goal: str # "Money", "Power", "Achievement"
    mbti_code: str # e.g. "INTJ"
    riasec_code: str # e.g. "R", "I" (Primary code from 123test)
    cognitive_scores: Optional[dict] = None # { "reaction_time": 200, "number_memory": 10, "verbal_memory": 50 }
    education_level: str # "10th", "12th", "Undergrad"
    domain_interest: Optional[str] = None # For undergrads

class JobRecommendation(BaseModel):
    onet_code: str
    title: str
    description: str
    match_score: float
    reasoning: List[str]

# --- Logic Placeholder ---
# --- Models for Roadmap ---
class RoadmapRequest(BaseModel):
    onet_code: str
    title: str
    education_level: str

# --- Logic Implementation ---
# Imports moved to lazy loading inside endpoints

job_matcher = None # Lazy init to ensure data is loaded first
gemini_service = None # Lazy init

@app.post("/recommend", response_model=List[JobRecommendation])
def recommend_jobs(profile: UserProfile):
    global job_matcher, gemini_service
    if gemini_service is None:
        from gemini_service import GeminiService
        gemini_service = GeminiService()
        
    if jobs_df is None or jobs_df.empty:
         raise HTTPException(status_code=500, detail="Job data not loaded")
    
    if job_matcher is None:
        from job_matcher import JobMatcher
        job_matcher = JobMatcher(jobs_df, gemini_service=gemini_service)

    print(f"Received Profile: {profile.life_goal} / {profile.mbti_code} / {profile.riasec_code}")
    
    # --- AI Domain Expansion ---
    ai_keywords = []
    if profile.education_level == "Undergrad" and profile.domain_interest:
        print(f"Expanding domain: {profile.domain_interest}")
        try:
            ai_keywords = gemini_service.expand_domain(profile.domain_interest)
        except Exception as e:
            print(f"Domain expansion failed, falling back: {e}")
            
    results = job_matcher.recommend(profile, ai_keywords=ai_keywords)
    return results

@app.post("/roadmap")
def get_roadmap(req: RoadmapRequest):
    # Try Gemini first if configured
    global gemini_service
    if gemini_service is None:
        from gemini_service import GeminiService
        gemini_service = GeminiService()

    if gemini_service.is_configured:
        print(f"Generating AI Roadmap for {req.title}")
        roadmap = gemini_service.generate_roadmap(req.title, req.education_level)
    else:
        print("Fallback to Static Roadmap")
        from roadmap_generator import RoadmapGenerator
        roadmap = RoadmapGenerator.generate(req.onet_code, req.title, req.education_level)
        
    return {"roadmap": roadmap}

if __name__ == "__main__":
    import uvicorn
    import os
    
    # Re-init service after loading env to catch key
    # (Optional, but good for safety if run directly)
    from gemini_service import GeminiService
    gemini_service = GeminiService() 
    
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
