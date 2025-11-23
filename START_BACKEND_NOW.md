# ⚠️ URGENT: Start Your Backend NOW!

## The Problem
Your backend is **NOT running**. That's why you're getting:
- `❌ Backend connection test failed: Connection timeout`
- Cannot connect to backend

## Quick Fix (2 Steps)

### Step 1: Open a NEW PowerShell Terminal

**Don't close your Flutter terminal!** Open a **separate** PowerShell window.

### Step 2: Start the Backend

Copy and paste these commands one by one:

```powershell
cd "C:\SaaS Projects\kloi\lira\backend"
```

Then:

```powershell
py -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**You MUST see this output:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Application startup complete.
```

### Step 3: Test It Works

In **another** PowerShell window, test:

```powershell
curl http://192.168.43.113:8000/health
```

Should return: `{"status":"ok"}`

### Step 4: Go Back to Your Flutter App

Once you see "Application startup complete" in the backend terminal:
1. Go back to your Flutter app
2. Open the voice analysis screen again
3. You should now see: `✅ Backend is connected!`

## ⚠️ IMPORTANT

- **Keep the backend terminal OPEN** - Don't close it!
- The backend must keep running while you use the app
- To stop it, press `CTRL+C` in the backend terminal

## Still Not Working?

1. Make sure your **phone and computer are on the SAME WiFi network**
2. Check Windows Firewall isn't blocking port 8000
3. Try testing from your phone's browser: `http://192.168.43.113:8000/health`

