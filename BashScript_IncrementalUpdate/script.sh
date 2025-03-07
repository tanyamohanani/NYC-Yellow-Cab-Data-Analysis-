#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <yyyy-mm>"
    exit 1
fi

# Assign the argument to a variable
date="$1"

# Define the directory to save the data
data_dir="./data/"

# Define the URL from which to pull data
url="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_${date}.parquet"

# Use curl to download the data and save it to the directory
curl -o "${data_dir}/yellow_tripdata_${date}.parquet" "${url}"

# Run your Python script to transform the data
/usr/bin/python3 main.py ${date}

# Run your SQL file
mysql -u "root" -p "test" < ./load.sql