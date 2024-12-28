import requests
import json
import time
from typing import Dict, Any

class GoogleMapsAPI:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://maps.googleapis.com/maps/api/place/textsearch/json"
        
    def verify_api_key(self) -> bool:
        """Test if the API key is valid."""
        test_params = {
            "query": "Acropolis Athens",
            "key": self.api_key
        }
        response = requests.get(self.base_url, params=test_params)
        if response.status_code == 200:
            data = response.json()
            return data.get("status") != "REQUEST_DENIED"
        return False

    def fetch_location_details(self, place_name: str) -> Dict[str, Any]:
        """Fetch details for a single location with better error handling."""
        params = {
            "query": place_name,
            "key": self.api_key
        }
        
        try:
            response = requests.get(self.base_url, params=params)
            response.raise_for_status()  # Raise an exception for bad status codes
            
            data = response.json()
            
            if data["status"] == "OK" and data["results"]:
                result = data["results"][0]
                return {
                    "name": result.get("name"),
                    "address": result.get("formatted_address"),
                    "latitude": result.get("geometry", {}).get("location", {}).get("lat"),
                    "longitude": result.get("geometry", {}).get("location", {}).get("lng"),
                    "rating": result.get("rating", "N/A"),
                    "place_id": result.get("place_id"),
                    "types": result.get("types", []),
                    "status": "FOUND"
                }
            else:
                print(f"Warning: No results found for '{place_name}'. Status: {data['status']}")
                return {
                    "name": place_name,
                    "status": "NOT_FOUND",
                    "error": data["status"]
                }
                
        except requests.exceptions.RequestException as e:
            print(f"Error fetching data for '{place_name}': {str(e)}")
            return {
                "name": place_name,
                "status": "ERROR",
                "error": str(e)
            }

def main():
    # Replace with your actual API key
    API_KEY = "AIzaSyCCfNrNDn4PM9vkFM3tMVcZLYbCCGpWAhc"
    
    # List of locations (your existing list)
    locations = [
    "Acropolis Museum, Athens",
    "National Museum of Contemporary Art, Athens",
    "Acropolis, Athens",
    "National Gallery, Athens",
    "Olympic Museum, Athens",
    "National Archaeological Museum, Athens",
    "Temple of Poseidon, Cape Sounion",
    "Temple of Olympian Zeus, Athens",
    "Panathenaic Stadium, Athens",
    "Goulandris Museum of Cycladic Art, Athens",
    "War Museum, Athens",
    "Old Parliament House, Athens",
    "Bronco Bar, Athens",
    "Ohh Boy Cafe, Athens",
    "Phellos Bar, Athens",
    "Makers Bar, Athens",
    "Anana Cafe, Athens",
    "Eteroclito Wine Bar, Athens",
    "Lovely Days Cafe, Peristeri",
    "Anafiotika, Athens",
    "Monastiraki Square, Athens",
    "Plaka, Athens",
    "Thiseio, Athens",
    "National Garden, Athens",
    "Ermou Street, Athens",
    "Sweet Nolan Bakery, Athens",
    "Bank Job Bar, Athens",
    "72h Bakery, Athens",
    "Ergon Restaurant, Athens",
    "Zillers Pastry Bar, Athens",
    "To Lokali Bar, Athens",
    "Ciel Cafe, Athens",
    "The Roosters Bar, Athens",
    "Dirty Sanchez Bar, Athens",
    "Bless Me Father Bar, Athens",
    "Drachmi Bar, Athens",
    "Lost Athens Bar, Athens",
    "Junior Does Wine Bar, Athens",
    "Drupes Cafe, Athens",
    "Bios Cultural Center, Athens",
    "EasyPeasy Bar, Athens",
    "Athens Concert Hall (Megaro Mousikis), Athens",
    "National Library of Greece, Athens",
    "National Theatre of Greece, Athens",
    "National Opera House, Athens",
    "Philopappos Hill, Athens",
    "Lycabettus Hill, Athens",
    "Stavros Niarchos Foundation Cultural Center, Athens",
    "Varvakios Central Market, Athens",
    "Technopolis Gazi, Athens"
]

    
    
    # Initialize the API client
    maps_api = GoogleMapsAPI(API_KEY)
    
    # Verify API key first
    if not maps_api.verify_api_key():
        print("Error: Invalid API key or API key has not been enabled for Places API")
        return
    
    # Fetch data for all locations
    results = {}
    for idx, location in enumerate(locations, start=1):
        print(f"Fetching data for: {location}")
        details = maps_api.fetch_location_details(location)
        results[f"loc{idx}"] = details
        
        # Respect API rate limits
        time.sleep(0.2)  # Small delay between requests
    
    # Save to a JSON file
    with open("locations_results.json", "w", encoding="utf-8") as file:
        json.dump(results, file, indent=4, ensure_ascii=False)
    
    # Print summary
    found_count = sum(1 for loc in results.values() if loc.get("status") == "FOUND")
    print(f"\nSummary:")
    print(f"Total locations processed: {len(locations)}")
    print(f"Successfully found: {found_count}")
    print(f"Not found: {len(locations) - found_count}")
    print("\nLocation data saved to locations_results.json")

if __name__ == "__main__":
    main()