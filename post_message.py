#!/usr/bin/env python

import requests
import json
import sys
import os

# Get all variables from environment

params = dict()

requireds = ['POST_MESSAGE', 
             'COMMENTS_URL', 
             'API_VERSION',
             'GITHUB_TOKEN']

for required in requireds:
    
    value = os.environ.get(required)
    if required == None:
        print('Missing environment variable %s' %required)
        sys.exit(1)

    params[required] = value

# If the user provided a file, read in the message
if os.path.exists(params["POST_MESSAGE"]):
    with open(params["POST_MESSAGE"], 'r') as filey:
        params["POST_MESSAGE"] = filey.read()

print(params["POST_MESSAGE"])

# Prepare request
accept = "application/vnd.github.%s+json;application/vnd.github.antiope-preview+json" % params['API_VERSION']
headers = {"Authorization": "token %s" % params['GITHUB_TOKEN'],
           "Accept": accept,
           "Content-Type": "application/json; charset=utf-8" }

data = {"body": params["POST_MESSAGE"] }
print(data)
print(json.dumps(data).encode('utf-8'))
response = requests.post(params['COMMENTS_URL'],
                         data = json.dumps(data).encode('utf-8'), 
                         headers = headers)
print(response.json())
print(response.status_code)
