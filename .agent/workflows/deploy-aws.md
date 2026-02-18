---
description: How to deploy Flying Elephant AI to AWS App Runner
---

### AWS Deployment Workflow (App Runner)

This workflow helps you deploy your Node.js backend to AWS with a custom domain.

1. **Push to GitHub**
   - Ensure your latest code (including the `Dockerfile` and `server/` folder) is pushed to your GitHub repository.

2. **Open AWS App Runner**
   - Go to the [AWS App Runner Console](https://console.aws.amazon.com/apprunner/home).
   - Click **Create service**.

3. **Source and Deployment**
   - Repository type: **Source code repository**.
   - Connect your GitHub account and select the `Flying-Elephant-ai` repository.
   - Deployment settings: **Automatic**.

4. **Configure Build**
   - Runtime: **Nodejs 18**.
   - Build command: `npm install --prefix server`.
   - Start command: `node server/index.js`.
   - Port: `3000`.

5. **Configure Service**
   - Environment variables:
     - `SARVAM_API_KEY`: (Your key)
     - `PORT`: `3000`
   - CPU & Memory: `1 vCPU / 2 GB` (Start small).

6. **Custom Domain Setup**
   - Once the service is "Running", go to the **Custom domains** tab in the App Runner service.
   - Add `www.flyingelephantai.com` (or your preferred domain).
   - AWS will provide CNAME records to add to your DNS provider (Route 53, GoDaddy, etc.).

7. **Update Flutter App**
   - Once you have your domain (e.g., `api.flyingelephantai.com`), update `search_repository.dart` to use this URL instead of the local IP.
