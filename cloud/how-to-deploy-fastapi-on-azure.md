Deploying a FastAPI App on Azure App Service (Linux)

Problem

You have a working FastAPI application locally, but deployments to Azure App Service often fail due to incorrect startup commands, missing environment configuration, or assumptions about how Azure runs Python apps.

This guide provides a clear, reproducible way to deploy a basic FastAPI app to Azure App Service (Linux) and validate that it is running correctly.

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

Prerequisites

•Azure subscription

•FastAPI app running locally

•Python 3.9+

•Azure CLI installed and logged in

•Git installed

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

Minimal FastAPI App Structure

project-root/

│

├─ app/

│ ├─ main.py

│

├─ requirements.txt

└─ startup.sh

app/main.py

from fastapi import FastAPI

app = FastAPI()

@app.get("/health")

def health():

return {"status": "ok"}

requirements.txt

fastapi

uvicorn

gunicorn

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

Step-by-Step Deployment

1\. Create Azure App Service (Linux)

•Runtime: Python 3.10 or 3.11

•OS: Linux

•SKU: Basic (B1) is sufficient

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

2\. Add Startup Script

startup.sh

#!/bin/bash

gunicorn -k uvicorn.workers.UvicornWorker -w 2 -b 0.0.0.0:8000 app.main:app

Make it executable:

chmod +x startup.sh

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

3\. Configure App Settings in Azure

In Configuration → Application settings, add:

•WEBSITES\_PORT = 8000

•SCM\_DO\_BUILD\_DURING\_DEPLOYMENT = true

Startup Command:

bash startup.sh

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

4\. Deploy Code

From the project root:

az webapp up --runtime "PYTHON:3.11" --sku B1

Or deploy via GitHub / Zip deploy.

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

Common Mistakes (and Fixes)

IssueCauseFix

App starts but site is downWrong portSet WEBSITES\_PORT=8000

ModuleNotFoundErrorWrong app pathUse app.main:app

App installs packages every restartNo build settingEnable SCM\_DO\_BUILD\_DURING\_DEPLOYMENT

Works locally, fails on AzureUsing uvicorn directlyUse gunicorn

Slow startupToo many workersStart with 2 workers

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

Validation Checklist

After deployment, verify:

1.App Service Logs

–App Service → Log stream

–Look for Application startup complete

2.Health Endpoint

–Visit:

https://.azurewebsites.net/health

–Expected response:

{"status":"ok"}

3.No Crash Loops

–Logs should not show repeated restarts

\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

Done

If /health returns ok and logs show a stable startup, your FastAPI app is successfully deployed.