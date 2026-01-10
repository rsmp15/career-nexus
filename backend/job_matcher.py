import pandas as pd
import re

from job_vector_store import JobVectorStore

class JobMatcher:
    def __init__(self, data: pd.DataFrame):
        self.data = data
        self.mappings = self._initialize_mappings()
        
        # Precompute lower case titles for speed
        self.data['title_lower'] = self.data['Title'].astype(str).str.lower()
        self.data['desc_lower'] = self.data['Description'].astype(str).str.lower()
        
        # Initialize Vector Store (RAG)
        print("Initializing Semantic Vector Store...")
        self.vector_store = JobVectorStore(data)

    def _initialize_mappings(self):
        # ... (Same as before, simplified for this snippet to focus on logic changes) ...
        return {
            "mbti": {
                # Analysts
                "INTJ": ["strategic", "logical", "planning", "architect", "science", "theory", "develop", "executive"],
                "INTP": ["innovative", "curious", "theory", "analyze", "academic", "research", "computer", "philosophical"],
                "ENTJ": ["leader", "decisive", "bold", "manage", "director", "executive", "operation", "business"],
                "ENTP": ["intellectual", "challenge", "entrepreneur", "stock", "marketing", "creative", "venture"],
                # Diplomats
                "INFJ": ["counsel", "inspire", "complex", "creative", "writer", "psycholo", "human"],
                "INFP": ["poetic", "kind", "altruistic", "art", "music", "write", "social", "nonprofit"],
                "ENFJ": ["lead", "inspire", "teach", "public", "social", "politic", "service"],
                "ENFP": ["enthusiastic", "creative", "social", "journal", "event", "promotion", "diplomat"],
                # Sentinels
                "ISTJ": ["fact", "reliable", "account", "audit", "administra", "police", "legal", "system"],
                "ISFJ": ["protect", "warm", "nurse", "teach", "child", "medicine", "social"],
                "ESTJ": ["manage", "administer", "supervise", "contract", "finance", "insurance", "officer"],
                "ESFJ": ["care", "social", "sale", "teach", "nurse", "health", "provider"],
                # Explorers
                "ISTP": ["bold", "practical", "mechanic", "engineer", "pilot", "driver", "detective", "fire"],
                "ISFP": ["flexible", "charm", "art", "design", "fashion", "landscape", "music"],
                "ESTP": ["smart", "energy", "sale", "police", "detective", "entrepreneur", "paramedic"],
                "ESFP": ["spontaneous", "perform", "actor", "music", "entertain", "event", "tour"]
            },
            "riasec": {
                "R": ["engineer", "mechanic", "driver", "pilot", "farm", "build", "technician", "hardware", "machine", "construct"],
                "I": ["analy", "scien", "research", "logic", "medic", "biolog", "chemist", "physic", "professor", "data"],
                "A": ["art", "design", "creat", "write", "music", "perform", "actor", "fashion", "media", "edit"],
                "S": ["social", "counsel", "teach", "nurse", "therap", "help", "care", "service", "psycholog", "human"],
                "E": ["manage", "business", "sale", "law", "politic", "entrepreneur", "chief", "lead", "project"],
                "C": ["account", "admin", "office", "clerk", "finance", "audit", "data", "record", "invnetory", "quality"]
            },
            "goals": {
                "Money": ["chief", "executive", "manage", "finance", "invest", "bank", "surgeon", "lawyer", "corporate", "director"],
                "Power": ["politic", "chief", "executive", "judge", "director", "officer", "manage", "admin", "lead"],
                "Achievement": ["research", "scien", "professor", "engineer", "architect", "invent", "doctor", "specialist"]
            }
        }

    def _get_cognitive_keywords(self, scores: dict):
        keywords = []
        if not scores:
            return keywords
            
        rt = scores.get("reaction_time", 300)
        nm = scores.get("number_memory", 5)
        vm = scores.get("verbal_memory", 30)

        # Reaction Time logic
        if rt < 210:
             keywords.extend(["pilot", "gamer", "emergency", "fire", "driver", "surgeon", "trade"])
        elif rt > 280:
             keywords.extend(["research", "writer", "architect", "strategy", "analy", "planning"])
        
        # Number Memory Logic
        if nm >= 12:
            keywords.extend(["backend", "data", "math", "cyber", "statistic", "physic"])
        elif nm >= 8:
            keywords.extend(["account", "finance", "code", "logistic"])
            
        # Verbal Memory Logic
        if vm > 60:
            keywords.extend(["law", "medic", "history", "linguist", "profess", "edit"])
        elif vm < 30:
            keywords.extend(["sport", "trade", "art", "perform"])

        return keywords

    def recommend(self, profile, ai_keywords: list = None):
        # 1. Aggregate Rule-Based Keywords (Legacy Logic - kept for Boosting)
        target_keywords = set()
        match_reasons = {} # kw -> source
        
        # ... (Mappings logic remains similar for creating a "Rule Score") ...
        # Add Domain Keywords
        domain_keywords = []
        if ai_keywords:
            domain_keywords = [k.lower() for k in ai_keywords]
        elif profile.education_level == "Undergrad" and profile.domain_interest:
             # Simple fallback tokenizer
             domain_keywords = [t.lower() for t in profile.domain_interest.split() if len(t) > 3]

        for k in domain_keywords:
            target_keywords.add(k)
            match_reasons[k] = "Major/Degree"
            
        # Add MBTI, RIASEC, Goals, Cognitive (Same as before)
        # ... (We reuse self.mappings for this) ...
        mbti_kws = self.mappings['mbti'].get(profile.mbti_code.upper(), [])
        for k in mbti_kws: target_keywords.add(k); match_reasons[k] = "Personality"
        
        riasec_kw = self.mappings['riasec'].get(profile.riasec_code.upper(), [])
        for k in riasec_kw: target_keywords.add(k); match_reasons[k] = "Aptitude"

        goal_kws = self.mappings['goals'].get(profile.life_goal, [])
        for k in goal_kws: target_keywords.add(k); match_reasons[k] = "Life Goal"
        
        if profile.cognitive_scores:
            cog_kws = self._get_cognitive_keywords(profile.cognitive_scores)
            for k in cog_kws: target_keywords.add(k); match_reasons[k] = "Cognitive"

        # 2. Semantic Search (RAG)
        # Construct a rich query string
        query_text = f"{profile.life_goal} career for {profile.mbti_code} {profile.riasec_code} person."
        if profile.domain_interest:
            query_text += f" specializing in {profile.domain_interest}."
        if ai_keywords:
             query_text += f" Interested in {', '.join(ai_keywords)}."
             
        # Get semantic matches (Top 100 candidates)
        if hasattr(self, 'vector_store'):
            semantic_results = self.vector_store.search(query_text, top_k=100)
        else:
            print("WARNING: Vector Store not initialized. Using fallback.")
            semantic_results = []

        # 3. Hybrid Scoring
        final_results = []
        
        # Map indices to semantic scores
        semantic_map = {res['index']: res['score'] for res in semantic_results}
        
        # Iterate only through candidates (or all if fallback)
        candidates_indices = semantic_map.keys() if semantic_map else range(len(self.data))
        
        for idx in candidates_indices:
            row = self.data.iloc[idx]
            
            # --- Rule Score Calculation ---
            rule_score = 0
            text_total = (str(row['Title']) + " " + str(row['Description'])).lower()
            
            matched_rules = []
            
            # Domain Boost (Super Critical)
            for dk in domain_keywords:
                if dk in text_total:
                    rule_score += 3.0
                    matched_rules.append(f"Major/Degree ({dk})")
                    break # One hit is enough for boost
            
            # Other Keywords
            for kw in target_keywords:
                if kw not in domain_keywords and kw.lower() in text_total:
                    rule_score += 0.5
                    # Tracking source 
                    src = match_reasons.get(kw, "Match")
                    if f"{src}" not in str(matched_rules): # Simple dedup
                        matched_rules.append(f"{src} ({kw})")

            # --- Final Combination ---
            # Vector Score is 0.0 to 1.0 (usually ~0.3 to 0.7 for good matches)
            # Rule Score can be 0.0 to 10.0+
            
            semantic_score = semantic_map.get(idx, 0.0)
            
            # Normalization heuristic: Semantic * 10 + Rule Score
            hybrid_score = (semantic_score * 10) + rule_score
            
            # Filter low quality matches
            if hybrid_score < 2.5: continue
            
            final_results.append({
                "onet_code": row['O*NET-SOC Code'],
                "title": row['Title'],
                "description": row['Description'],
                "match_score": hybrid_score,
                "reasoning": matched_rules[:3] if matched_rules else ["AI Semantic Match"]
            })
            
        final_results.sort(key=lambda x: x['match_score'], reverse=True)
        return final_results[:20]
