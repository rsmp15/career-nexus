class RoadmapGenerator:
    @staticmethod
    def generate(job_code: str, job_title: str, level: str):
        """
        Generates a roadmap string (Markdown) based on the specific job code or title.
        Uses heuristics on the O*NET code prefix (e.g. 15-xxxx is Computer).
        """
        code_prefix = job_code[:2] if job_code else "00"
        
        roadmap = f"# Career Roadmap: {job_title}\n"
        roadmap += f"**Current Level:** {level}\n\n"

        # --- High Level Strategy ---
        if level == "10th":
            roadmap += "## Phase 1: Foundation (High School)\n"
            if code_prefix in ["15", "17", "19"]: # STEM
                roadmap += "- **Streams**: Choose Science (PCM/PCB) depending on exact field.\n"
                roadmap += "- **Focus**: Strong Math and Logic skills.\n"
            elif code_prefix in ["11", "13"]: # Business
                roadmap += "- **Streams**: Commerce or Arts with Economics/Math.\n"
                roadmap += "- **Focus**: Communication and Leadership roles in school clubs.\n"
            else:
                 roadmap += "- **Streams**: Choose a stream aligned with your passion (Arts for Design, etc).\n"
            
            roadmap += "- **Exams**: Prepare for entrance exams like JEE (for Engineering), NEET (Medical), or CLAT (Law).\n\n"

        elif level == "12th":
             roadmap += "## Phase 1: Undergraduate Selection\n"
             roadmap += "- **Goal**: Secure admission in a top-tier college.\n"
             roadmap += "- **Action**: Research degrees relevant to this field.\n"
             if code_prefix == "15":
                 roadmap += "- **Degree**: B.Tech/B.E in CS, IT, or BCA/B.Sc Computer Science.\n"
             elif code_prefix == "17":
                  roadmap += "- **Degree**: B.Tech in Mechanical, Civil, Electrical etc.\n"
             elif code_prefix == "29":
                  roadmap += "- **Degree**: MBBS, B.Pharma, or Nursing.\n"
             elif code_prefix == "11":
                  roadmap += "- **Degree**: BBA, BBM, or B.Com.\n"
             roadmap += "\n"

        elif level == "Undergrad":
            roadmap += "## Phase 1: Skill Specialization\n"
            roadmap += "- **Goal**: Bridge the gap between theory and industry.\n"
            roadmap += "- **Action**: Internships and real-world projects.\n\n"
        
        # --- Domain Specifics ---
        roadmap += "## Phase 2: Professional Development\n"
        if code_prefix == "15": # Computer
            roadmap += "### 🛠️ Technical Skills\n"
            roadmap += "- **Languages**: Python, Java, C++, JavaScript.\n"
            roadmap += "- **Core**: DSA (Data Structures & Algorithms), OOPS, DBMS.\n"
            roadmap += "- **Tools**: Git, VS Code, Linux, Docker.\n"
            roadmap += "### 🚀 Projects\n"
            roadmap += "- Build a full-stack web app.\n"
            roadmap += "- Contribute to Open Source on GitHub.\n"
            
        elif code_prefix == "17": # Engineering
            roadmap += "- **Certifications**: CAD/CAM, AutoCAD, MATLAB.\n"
            roadmap += "- **Exams**: GATE (for higher studies/PSUs).\n"
            
        elif code_prefix == "11" or code_prefix == "13": # Management
            roadmap += "- **MBA**: Consider preparing for CAT/GMAT for a Masters.\n"
            roadmap += "- **Skills**: Excel (Advanced), PowerBI, Public Speaking.\n"
            
        elif code_prefix == "29": # Healthcare
            roadmap += "- **Residency/Specialization**: Prepare for PG entrance.\n"
            roadmap += "- **Experience**: Clinical rotations are crucial.\n"
        
        elif code_prefix == "27": # Arts/Media
             roadmap += "- **Portfolio**: Build a Behance/Dribbble portfolio.\n"
             roadmap += "- **Networking**: Connect with creators on LinkedIn/Instagram.\n"

        else:
            roadmap += "- Research specific certifications for this role.\n"
            roadmap += "- Network with professionals on LinkedIn.\n"

        roadmap += "\n## Phase 3: Job Hunt\n"
        roadmap += "- **Platforms**: LinkedIn, Indeed, Glassdoor.\n"
        roadmap += "- **Resume**: Tailor your resume to highlight the skills above.\n"
        
        return roadmap
