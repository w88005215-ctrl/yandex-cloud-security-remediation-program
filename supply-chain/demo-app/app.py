from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/")
def index():
    return jsonify(
        status="ok",
        component="ycsec-supply-chain-demo",
        purpose="controlled supply-chain validation"
    )

@app.get("/healthz")
def healthz():
    return jsonify(status="healthy")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
