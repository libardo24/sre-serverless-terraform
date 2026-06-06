## Linux

API_URL="https://30l9ppn0gf.execute-api.us-east-1.amazonaws.com"
curl -i -X POST "${API_URL}/process" \
  -H 'Content-Type: application/json' \
  -d '{"text":"Realizando una petición"}'
HTTP/2 200 
date: Sat, 06 Jun 2026 18:14:59 GMT
content-type: application/json
content-length: 145
x-cache: MISS
apigw-requestid: ejSBWh-UoAMEMEA=
{"input": {"text": "Realizando una petici\u00f3n"}, "output": "n\u00f3icitep anu odnazilaeR", "processed_at": "2026-06-06T18:14:58.971129+00:00"}


## Windows

aws s3 ls s3://sre-prueba-tecnica-590183747610-us-east-1-results/results/ --recursive
2026-06-06 13:16:28        145 results/2026-06-06/147277c910b00dd1a49cdc8946e486d09b546105f28377a79c581a58b94bec0c.json
2026-06-06 13:15:51        184 results/2026-06-06/a8f4e12e82dbdb1e6a221f8933cf708167c5a283abd2aa42e376cc0dfcfe0a95.json

