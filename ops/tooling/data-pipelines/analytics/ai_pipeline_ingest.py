"""
AI Pipeline telemetry ingestion stub.

This script simulates pulling inference telemetry from the AI service and emitting
structured JSON lines that downstream analytics jobs (Athena/Glue) can consume.
"""

import json
import os
import random
from datetime import datetime, timedelta

OUTPUT_DIR = os.getenv("AI_TELEMETRY_OUTPUT_DIR", "./tmp/analytics")
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "ai_pipeline_runs.jsonl")

MODELS = [
    {
        "model_id": "attrition-risk-model",
        "version": "0.1.0",
        "tenant_id": "11111111-2222-3333-4444-555555555555",
    },
    {
        "model_id": "payroll-anomaly-detector",
        "version": "0.2.0",
        "tenant_id": "11111111-2222-3333-4444-555555555555",
    },
]


def generate_run(model):
    triggered_at = datetime.utcnow() - timedelta(minutes=random.randint(5, 120))
    duration = random.randint(2, 20)
    completed_at = triggered_at + timedelta(minutes=duration)
    status = random.choices(["succeeded", "failed"], weights=[0.85, 0.15])[0]
    metrics = {
        "latency_p95_ms": random.randint(1200, 2200),
        "drift_score": round(random.random() * 0.2, 3),
        "data_rows": random.randint(5000, 20000),
    }

    return {
        "tenant_id": model["tenant_id"],
        "run_id": f"run-{random.randint(1000, 9999)}",
        "model_id": model["model_id"],
        "model_version": model["version"],
        "status": status,
        "triggered_at": triggered_at.isoformat() + "Z",
        "completed_at": completed_at.isoformat() + "Z" if status == "succeeded" else None,
        "metrics": metrics,
        "telemetry_bucket": f"s3://ml-telemetry/{model['model_id']}/{triggered_at.date()}/",
    }


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    runs = [generate_run(model) for model in MODELS]

    with open(OUTPUT_FILE, "a", encoding="utf-8") as handle:
        for run in runs:
            handle.write(json.dumps(run) + "\n")

    print(f"Generated {len(runs)} AI pipeline telemetry records -> {OUTPUT_FILE}")


if __name__ == "__main__":
    main()

