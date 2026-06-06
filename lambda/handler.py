import os
import json
import base64
import hashlib
import logging
from datetime import datetime, timezone

import boto3
import redis

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client("s3")
S3_BUCKET = os.environ["S3_BUCKET"]
REDIS_HOST = os.environ["REDIS_HOST"]
REDIS_PORT = int(os.environ.get("REDIS_PORT", "6379"))
CACHE_TTL = int(os.environ.get("CACHE_TTL", "60"))


def parse_body(event):
    body = event.get("body") or "{}"
    if event.get("isBase64Encoded"):
        body = base64.b64decode(body).decode("utf-8")
    return body


def process_payload(raw_body: str):
    try:
        parsed = json.loads(raw_body)
    except json.JSONDecodeError:
        parsed = {"raw": raw_body}

    text = parsed.get("text", raw_body)
    transformed = text[::-1]
    now = datetime.now(timezone.utc)

    return {
        "input": parsed,
        "output": transformed,
        "processed_at": now.isoformat(),
    }


def response(status_code: int, body: dict, cache_status: str | None = None):
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
    }
    if cache_status:
        headers["X-Cache"] = cache_status
    return {
        "statusCode": status_code,
        "headers": headers,
        "body": json.dumps(body),
    }


def lambda_handler(event, context):
    try:
        raw_body = parse_body(event)
        cache_key = hashlib.sha256(raw_body.encode("utf-8")).hexdigest()
        redis_client = redis.Redis(
            host=REDIS_HOST,
            port=REDIS_PORT,
            decode_responses=True,
            socket_connect_timeout=2,
            socket_timeout=2,
        )

        cached = redis_client.get(cache_key)
        if cached:
            logger.info("cache_hit key=%s", cache_key)
            return {
                "statusCode": 200,
                "headers": {
                    "Content-Type": "application/json",
                    "Access-Control-Allow-Origin": "*",
                    "X-Cache": "HIT",
                },
                "body": cached,
            }

        result = process_payload(raw_body)
        payload = json.dumps(result)

        date_prefix = datetime.now(timezone.utc).strftime("%Y-%m-%d")
        object_key = f"results/{date_prefix}/{cache_key}.json"

        s3.put_object(
            Bucket=S3_BUCKET,
            Key=object_key,
            Body=payload.encode("utf-8"),
            ContentType="application/json",
        )

        redis_client.setex(cache_key, CACHE_TTL, payload)
        logger.info("cache_miss key=%s object_key=%s", cache_key, object_key)

        return {
            "statusCode": 200,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "X-Cache": "MISS",
            },
            "body": payload,
        }
    except Exception as exc:
        logger.exception("processing_error")
        return response(
            500,
            {"error": "processing_error", "message": str(exc)},
        )
