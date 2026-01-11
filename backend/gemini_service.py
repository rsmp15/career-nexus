import os
import google.generativeai as genai
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type
from google.api_core import exceptions
import logging

# Fallback generator
from roadmap_generator import RoadmapGenerator

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class GeminiService:
    def __init__(self):
        api_key = os.getenv("GEMINI_API_KEY")
        self.is_configured = False
        self.model = None

        if api_key:
            genai.configure(api_key=api_key)
            self.model = self._configure_model()
            if self.model:
                self.is_configured = True
        else:
            logger.warning("GEMINI_API_KEY not found.")

    def _configure_model(self):
        """
        Tries to find a working model from a prioritized list.
        """
        candidate_models = [
            "gemini-1.5-flash",
            "gemini-2.0-flash-lite",
            "gemini-flash-latest",
            "gemini-1.5-pro-latest"
        ]
        
        # 1. Try to list models and find an exact match
        try:
            available_models = [m.name.replace('models/', '') for m in genai.list_models()]
            logger.info(f"Available models: {available_models}")
            
            for candidate in candidate_models:
                if candidate in available_models:
                    logger.info(f"Selected model: {candidate}")
                    return genai.GenerativeModel(candidate)
        except Exception as e:
            logger.warning(f"Failed to list models: {e}. Falling back to trial.")

        # 2. If listing fails or no match, just try instantiating the first preferred one
        # defaulting to 1.5-flash as it's the current standard
        return genai.GenerativeModel("gemini-1.5-flash")

    @retry(
        retry=retry_if_exception_type((exceptions.ResourceExhausted, exceptions.ServiceUnavailable)),
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=2, max=10)
    )
    def _call_ai(self, prompt):
        return self.model.generate_content(
            prompt,
            safety_settings=[
                {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"},
                {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_ONLY_HIGH"},
            ]
        )

    from functools import lru_cache

    @lru_cache(maxsize=100)
    def generate_roadmap(self, role: str, level: str) -> str:
        # Static Roadmap Fallback Helper
        def get_static_roadmap():
            logger.info("Generating static roadmap fallback.")
            return RoadmapGenerator.generate("00-0000", role, level)

        if not self.is_configured or not self.model:
            return get_static_roadmap()
        
        prompt = f"""
        Act as a Senior Career Strategist. Create a detailed career roadmap for '{role}' (Level: {level}).
        Format: Markdown.
        
        # Roadmap: {role}
        **Strategic North Star**: [One sentence goal]
        
        ## 📊 Market Stats
        | Level | Income | Status |
        | :--- | :--- | :--- |
        | **Entry** | $X | Growing |
        | **Senior** | $Y | High |
        
        ## 🗺️ Strategy
        ### Phase 1: Foundation
        - **Objective**: [Goal]
        - **Skills**: [Tools]
        - **Actions**: [Steps]
        
        ### Phase 2: Mastery
        - **Objective**: [Goal]
        - **Projects**: [Ideas]
        
        ## 🛑 Risks
        - [Bottleneck] -> [Solution]
        """
        
        try:
            response = self._call_ai(prompt)
            return response.text
        except Exception as e:
            logger.error(f"AI Generation failed: {e}")
            return get_static_roadmap()

    def expand_domain(self, domain_interest: str) -> list[str]:
        """
        Uses AI to find diverse job titles related to a study domain.
        Example: "Data Science" -> ["Data Scientist", "Machine Learning Engineer", "Data Analyst"]
        """
        if not self.is_configured or not self.model or not domain_interest:
            return []
            
        prompt = f"""
        List 5 distinct, professional job titles for a student specializing in '{domain_interest}'.
        Return ONLY a comma-separated list of titles. No numbering or extra text.
        """
        try:
            response = self._call_ai(prompt)
            text = response.text.replace('\n', '')
            # Clean and split
            keywords = [k.strip() for k in text.split(',') if k.strip()]
            logger.info(f"AI Expanded '{domain_interest}' to: {keywords}")
            return keywords
        except Exception as e:
            logger.error(f"Domain expansion failed: {e}")
            return []
    def get_embedding(self, text: str) -> list[float]:
        """
        Generates embeddings using the Gemini API.
        """
        if not self.is_configured:
            logger.warning("Gemini Service not configured, returning empty embedding.")
            return []
            
        try:
            # Using the new text-embedding-004 model
            result = genai.embed_content(
                model="models/text-embedding-004",
                content=text,
                task_type="retrieval_document",
                title="Job Description" 
            )
            return result['embedding']
        except Exception as e:
            logger.error(f"Embedding generation failed: {e}")
            return []
