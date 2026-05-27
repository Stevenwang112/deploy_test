import os
from datetime import datetime

from flask import Flask, jsonify

app = Flask(__name__)

HOSTNAME = os.environ.get("HOSTNAME", "unknown")


@app.route("/")
def index():
    return jsonify(
        {
            "message": "Hello from my-webapp!",
            "hostname": HOSTNAME,
            "time": datetime.utcnow().isoformat() + "Z",
        }
    )


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
