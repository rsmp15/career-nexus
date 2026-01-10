import requests
import json

base_url = "http://127.0.0.1:8000"

def test_recommendation():
    print("Testing /recommend...")
    payload = {
        "life_goal": "Money",
        "mbti_code": "ENTJ",
        "riasec_code": "E", # Enterprising
        "education_level": "Undergrad",
        "cognitive_scores": {
            "reaction_time": 250,
            "number_memory": 9,
            "verbal_memory": 40
        }
    }
    
    try:
        response = requests.post(f"{base_url}/recommend", json=payload)
        if response.status_code == 200:
            data = response.json()
            print(f"Success! Got {len(data)} recommendations.")
            for i, job in enumerate(data[:3]):
                print(f"{i+1}. {job['title']} (Score: {job['match_score']})")
                print(f"   Reasons: {job['reasoning']}")
        else:
            print(f"Error: {response.status_code} - {response.text}")
    except Exception as e:
        print(f"Failed to connect: {e}")

def test_roadmap():
    print("\nTesting /roadmap...")
    payload = {
        "onet_code": "11-1011.00", # Chief Exec
        "title": "Chief Executives",
        "education_level": "Undergrad"
    }
    try:
        response = requests.post(f"{base_url}/roadmap", json=payload)
        if response.status_code == 200:
            print("Success! Roadmap snippet:")
            print(response.json()['roadmap'][:200] + "...")
        else:
            print(f"Error: {response.status_code}")
    except Exception as e:
        print(f"Failed to connect: {e}")

if __name__ == "__main__":
    test_recommendation()
    test_roadmap()
