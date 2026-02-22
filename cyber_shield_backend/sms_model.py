# sms_model.py

from transformers import pipeline

classifier = pipeline(
    "text-classification",
    model="distilbert-base-uncased-finetuned-sst-2-english"
)

def analyze_sms(text: str):
    result = classifier(text)[0]

    label = result["label"]
    score = round(result["score"] * 100)

    # Simple logic for demo
    if "otp" in text.lower() or "urgent" in text.lower():
        return {
            "risk_score": 85,
            "label": "Scam",
            "reason": "Urgency or OTP pattern detected."
        }

    return {
        "risk_score": score,
        "label": "Safe" if label == "POSITIVE" else "Suspicious",
        "reason": "AI sentiment analysis completed."
    }