# ---------- Zip Code ----------
zip function.zip main.py requirements.txt


# ---------- Enable APIs ----------
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services list --enabled


# ---------- Grant Access to Function ----------
gcloud functions add-iam-policy-binding put_api_function \
--project="new-devops-project-1" \
--region="europe-west2" \
--member="allUsers" \
--role="roles/cloudfunctions.invoker"


# ---------- Test the Function (via curl) ----------
curl -X PUT -H "Content-Type: application/json" \
-d '{"id": 123212, "name": "Testing"}' \
https://your-api-url
