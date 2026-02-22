# url_model.py

import tldextract

def analyze_url(url: str):
    risk = 0

    if "@" in url:
        risk += 30

    if len(url) > 75:
        risk += 20

    if "http://" in url:
        risk += 20

    extracted = tldextract.extract(url)
    if len(extracted.subdomain) > 15:
        risk += 20

    if risk > 60:
        label = "Phishing"
    elif risk > 30:
        label = "Suspicious"
    else:
        label = "Safe"

    return {
        "risk_score": risk,
        "label": label,
        "reason": "Feature-based phishing analysis completed."
    }