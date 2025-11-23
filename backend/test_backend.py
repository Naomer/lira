#!/usr/bin/env python3
"""
Simple script to test if the backend is running and accessible.
Run this to verify your backend setup before testing the Flutter app.
"""

import sys
import requests
import time

def test_backend():
    """Test if backend is running and responding."""
    url = "http://localhost:8000/health"
    
    print("🔍 Testing backend connection...")
    print(f"📍 URL: {url}")
    print()
    
    try:
        response = requests.get(url, timeout=5)
        
        if response.status_code == 200:
            print("✅ SUCCESS! Backend is running and responding!")
            print(f"📦 Response: {response.json()}")
            print()
            print("🎉 Your backend is ready! You can now test the Flutter app.")
            return True
        else:
            print(f"❌ Backend returned status code: {response.status_code}")
            print(f"📦 Response: {response.text}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ ERROR: Cannot connect to backend!")
        print()
        print("💡 The backend is not running. Start it with:")
        print("   py -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000")
        return False
        
    except requests.exceptions.Timeout:
        print("❌ ERROR: Connection timeout!")
        print("💡 Backend might be starting up. Wait a few seconds and try again.")
        return False
        
    except Exception as e:
        print(f"❌ ERROR: {e}")
        return False

if __name__ == "__main__":
    print("=" * 60)
    print("Lira Backend Connection Test")
    print("=" * 60)
    print()
    
    success = test_backend()
    
    print()
    print("=" * 60)
    
    if success:
        print("✅ All good! Backend is ready.")
        sys.exit(0)
    else:
        print("❌ Backend is not accessible. Please start it first.")
        sys.exit(1)

