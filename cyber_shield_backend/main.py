from fastapi import FastAPI
from sms_model import analyze_sms
from url_model import analyze_url

app = FastAPI()

@app.get("/")
def home():
    return {"message": "AI Cyber Shield Running"}

@app.post("/analyze_sms")
def sms_scan(payload: dict):
    text = payload.get("text")
    return analyze_sms(text)

@app.post("/analyze_url")
def url_scan(payload: dict):
    url = payload.get("url")
    return analyze_url(url)