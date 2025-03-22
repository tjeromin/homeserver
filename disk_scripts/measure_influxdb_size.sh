#!/bin/bash

# InfluxDB Configuration
INFLUXDB_HOST="localhost"
INFLUXDB_PORT="8086"
ORG="tino"
BUCKET="system_stats"
MEASUREMENT="influxdb_size"
TYPE="total"
INFLUX_API_TOKEN="i0pKgBRFqwCsrE_1mKqW2QhOhOfzN9OFIqyLmUWVlNHis3SW0u2nIDW4pHIooyCQ5zleBGh9nUsKAEeNN3VrFQ=="

# Folder to be monitored
FOLDER_PATH="/mnt/drive1/influxdb/"

# Get the size of the folder in bytes and only keep first output string
FOLDER_SIZE=$(du -sb "$FOLDER_PATH" | awk '{print $1}')

# Get the current Unix timestamp in seconds
TIMESTAMP=$(date +%s)

# InfluxDB Line Protocol format
LINE_PROTOCOL="${MEASUREMENT},type=${TYPE} size=${FOLDER_SIZE} ${TIMESTAMP}"

# InfluxDB HTTP API URL
INFLUXDB_URL="http://${INFLUXDB_HOST}:${INFLUXDB_PORT}/api/v2/write?org=${ORG}&bucket=${BUCKET}&precision=s"

# Send the data to InfluxDB using curl
curl -i -XPOST "${INFLUXDB_URL}" --data-binary "${LINE_PROTOCOL}" --header "Authorization: Token ${INFLUX_API_TOKEN}"

# Print a message indicating the completion of the operation
echo "Folder size sent to InfluxDB: ${FOLDER_SIZE} bytes"
