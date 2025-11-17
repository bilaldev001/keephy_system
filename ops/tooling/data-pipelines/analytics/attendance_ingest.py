"""
Mock ingestion job for analytics pipeline sprint slice.

This script fetches attendance records from the EMS API and writes them
to a local parquet/csv file that simulates an S3 landing zone for Athena.
"""
import json
import os
import pathlib
import sys
from datetime import datetime, timedelta
from typing import Any, Dict, List

import requests

GATEWAY_URL = os.environ.get("GATEWAY_URL", "http://localhost:4000")
OUTPUT_DIR = pathlib.Path(os.environ.get("ANALYTICS_OUTPUT_DIR", "./tmp/analytics"))
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


def fetch_attendance(window_days: int = 7) -> List[Dict[str, Any]]:
    """Pull attendance window from EMS routes."""
    start_date = datetime.utcnow() - timedelta(days=window_days)
    params = {
        "since": start_date.isoformat(),
        "limit": 500,
    }
    response = requests.get(f"{GATEWAY_URL}/ems/attendance", params=params, timeout=10)
    response.raise_for_status()
    payload = response.json()
    return payload.get("data", [])


def write_jsonl(records: List[Dict[str, Any]], filename: pathlib.Path) -> None:
    with filename.open("w", encoding="utf-8") as handle:
        for record in records:
            handle.write(json.dumps(record))
            handle.write("\n")


def main() -> None:
    try:
        records = fetch_attendance()
    except requests.RequestException as exc:
        print(f"[attendance_ingest] failed to fetch attendance: {exc}", file=sys.stderr)
        sys.exit(1)

    if not records:
        print("[attendance_ingest] no attendance records found; skipping write")
        return

    timestamp = datetime.utcnow().strftime("%Y%m%d%H%M%S")
    output_file = OUTPUT_DIR / f"attendance_{timestamp}.jsonl"
    write_jsonl(records, output_file)

    print(f"[attendance_ingest] wrote {len(records)} records to {output_file}")


if __name__ == "__main__":
    main()

