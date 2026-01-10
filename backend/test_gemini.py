from gemini_service import GeminiService
import logging

logging.basicConfig(level=logging.INFO)

print("--- Testing Gemini Service ---")
service = GeminiService()

if not service.is_configured:
    print("❌ Service NOT configured (API Key missing?)")
else:
    print(f"✅ Service Configured with Model: {service.model.model_name}")
    
    print("\nAttempting to generate roadmap...")
    try:
        # Call internal method to see raw exceptions if any, or public method
        result = service.generate_roadmap("Software Engineer", "Undergrad")
        print("\n--- Result ---")
        print(result[:500] + "...")
        print("--- End Result ---")
        
        if "Static Roadmap" in result or "AI Service encountered an error" in result:
             print("\n⚠️  Warning: Fallback or Error detected in output.")
        else:
             print("\n✅ Success: AI content generated.")
             
    except Exception as e:
        print(f"\n❌ CRITICAL EXCEPTION: {e}")
