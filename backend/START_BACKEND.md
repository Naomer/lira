# How to Start the Backend

## Quick Start (Windows PowerShell)

### Step 1: Install Dependencies

```powershell
# Make sure you're in the backend directory
cd backend

# Install Python packages
py -m pip install -r requirements.txt
```

**If `py` doesn't work, try:**
- `python -m pip install -r requirements.txt`
- `python3 -m pip install -r requirements.txt`

### Step 2: Start the Backend Server

```powershell
# From the backend directory
py -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Alternative commands if `py` doesn't work:**
- `python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`
- `python3 -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`

### Step 3: Verify It's Running

You should see:
```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

### Step 4: Test the Backend

Open a **new** PowerShell window and run:
```powershell
curl http://localhost:8000/health
```

Should return: `{"status":"ok"}`

## Troubleshooting

### "Python was not found"
- Install Python from https://www.python.org/downloads/
- Make sure to check "Add Python to PATH" during installation

### "No module named pip"
- Reinstall Python with pip included
- Or run: `py -m ensurepip --upgrade`

### "No module named uvicorn"
- Run: `py -m pip install -r requirements.txt`

### Port 8000 already in use
- Change the port: `--port 8001`
- Update `lib/config/api_config.dart` to match

## Keep This Terminal Open!

**Important:** Keep the terminal running uvicorn open. Closing it will stop the backend server.

To stop the server, press `CTRL+C` in the terminal.

