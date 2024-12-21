import firebase_admin
from firebase_admin import credentials, firestore
import json

def initialize_firebase():
    """Initialize Firebase Admin SDK"""
    try:
        cred = credentials.Certificate("vibeandseek-ac0bc-firebase-adminsdk-quw2w-ab4e9ce442.json")
        firebase_admin.initialize_app(cred)
        return firestore.client()
    except Exception as e:
        print(f"Error initializing Firebase: {str(e)}")
        return None

def process_location_data(data):
    """Special processing for location data"""
    if isinstance(data, dict):
        # Process coordinates and clean up location data
        if "latitude" in data and "longitude" in data:
            data["coordinates"] = {
                "latitude": data["latitude"],
                "longitude": data["longitude"]
            }
    return data

def import_collection(db, filename, collection_name):
    """Import a single collection from a JSON file"""
    try:
        # Open file with UTF-8 encoding
        with open(filename, 'r', encoding='utf-8') as file:
            data = json.load(file)
            
            # Handle both direct data and nested collection data
            collection_data = data.get(collection_name, data)
            
            # Use batched writes for better performance
            batch = db.batch()
            count = 0
            batch_size = 500
            
            for doc_id, doc_data in collection_data.items():
                # Special processing for locations
                if collection_name == "Locations":
                    doc_data = process_location_data(doc_data)
                
                doc_ref = db.collection(collection_name).document(doc_id)
                batch.set(doc_ref, doc_data)
                count += 1
                
                # Commit batch when size limit is reached
                if count >= batch_size:
                    batch.commit()
                    print(f"Committed batch of {count} documents to {collection_name}")
                    batch = db.batch()
                    count = 0
            
            # Commit any remaining documents
            if count > 0:
                batch.commit()
                print(f"Committed final batch of {count} documents to {collection_name}")
                
            print(f"Successfully imported {len(collection_data)} documents to {collection_name}")
            
    except FileNotFoundError:
        print(f"File not found: {filename}")
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON in {filename}: {str(e)}")
    except Exception as e:
        print(f"Error importing {collection_name}: {str(e)}")

def main():
    # Initialize Firebase
    db = initialize_firebase()
    if not db:
        return
    
    # Define collections to import
    collections = [
        ("users.json", "Users"),
        ("challenges.json", "Challenges"),
        ("preferences.json", "Preferences"),
        ("user_preferences.json", "User_Preferences"),
        ("locations.json", "Locations"),
        ("user_wishlist.json", "User_Wishlist"),
        ("locations_preferences.json", "Locations_Preferences")
    ]
    
    # Import each collection
    for filename, collection_name in collections:
        print(f"\nImporting {collection_name} from {filename}...")
        import_collection(db, filename, collection_name)

if __name__ == "__main__":
    main()