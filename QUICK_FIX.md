# Quick Fix: Backend Connection Issue

## The Problem
Your Flutter app can't connect to the backend because:
1. **Backend is not running** OR
2. **App needs full restart** (not just hot reload)

## Solution (3 Steps)

### Step 1: Start the Backend Server

Open a **NEW** PowerShell terminal and run:

```powershell
cd "C:\SaaS Projects\kloi\lira\backend"
py -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**You should see:**
```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Application startup complete.
```

**⚠️ KEEP THIS TERMINAL OPEN!** Don't close it.

### Step 2: Test Backend is Working

Open **ANOTHER** PowerShell terminal and test:

```powershell
curl http://localhost:8000/health
```

**Should return:** `{"status":"ok"}`

If you get an error, the backend isn't running. Go back to Step 1.

### Step 3: FULLY RESTART Flutter App

**Important:** You need to **STOP and RESTART** the app, not just hot reload!

1. **Stop the app** (press `q` in Flutter terminal, or close it)
2. **Restart it:**
   ```powershell
   flutter run
   ```

3. **Open the voice analysis screen** - you should now see:
   - `✅ Backend is connected!` in the console
   - No error message in the app

## Why Full Restart?

The config change (Android → 10.0.2.2:8000) requires a full app restart. Hot reload (`r`) doesn't reload platform detection.

## Still Not Working?

### Check the Console Logs

When you open the voice screen, look for:
```
🔍 Testing backend connection...
🔍 Testing backend at: http://10.0.2.2:8000/health
```

If it says `localhost:8000` instead of `10.0.2.2:8000`, the app didn't restart properly.

### Manual Override (If Auto-Detection Fails)

Edit `lib/config/api_config.dart` and uncomment this line:
```dart
static const String? manualBackendUrl = 'http://10.0.2.2:8000';
```

Change it from `null` to `'http://10.0.2.2:8000'`, then restart the app.

## Quick Checklist

- [ ] Backend terminal is running (showing "Uvicorn running...")
- [ ] `curl http://localhost:8000/health` returns `{"status":"ok"}`
- [ ] Flutter app was **fully restarted** (not just hot reloaded)
- [ ] Console shows `✅ Backend is connected!`
- [ ] No error message in the app

## Need More Help?

Check the console logs for:
- What URL it's trying to connect to
- Any error messages
- Whether it says "Android detected" or not

Share those logs if you're still stuck!

