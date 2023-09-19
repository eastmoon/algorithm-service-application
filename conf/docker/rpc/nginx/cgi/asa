#!/usr/bin/env python

# Import library
import os
import sys
import json
import re
import cgi

# Declare function
def parser_request_info():
    data = ""
    if os.environ['CONTENT_LENGTH'] != "":
        data = json.loads(sys.stdin.read())
    return {
        'REQUEST_URI': os.environ['REQUEST_URI'],
        'REQUEST_METHOD': os.environ['REQUEST_METHOD'],
        'SCRIPT_FILENAME': os.environ['SCRIPT_FILENAME'],
        'SCRIPT_NAME': os.environ['SCRIPT_NAME'],
        'QUERY_STRING': os.environ['QUERY_STRING'],
        'CONTENT_TYPE': os.environ['CONTENT_TYPE'],
        'CONTENT_LENGTH': os.environ['CONTENT_LENGTH'],
        'CONTENT': data
    }

def parser_restful_info(url):
    # Regex for get the related fields from URL
    url_pattern = r'/(?P<api>\w+)/(?P<id>[0-9]+)/(?P<name>\w+)$'
    return re.match(url_pattern, url).groupdict()

def response(status, message):
    result = {
        "status": status,
        "message": message
    }
    print "Content-type: application/json"
    print ""
    print json.dumps(result)

def call_get(info):
    return {
        "text": "Call GET method, and retrieve information.",
        "body": info
    }

def call_post(info):
    return {
        "text": "Call POST method, new information with body.",
        "body": info["req"]["CONTENT"]
    }

def call_put(info):
    return {
        "text": "Call PUT method, update information with body.",
        "body": info["req"]["CONTENT"]
    }

def call_del(info):
    return "Call DELETE method, and remove information."

switch = {"GET": call_get, "POST": call_post, "PUT": call_put, "DELETE": call_del}
# Execute script
try:
    req = parser_request_info()
    info = {
        "restful": parser_restful_info(req["SCRIPT_NAME"]),
        "req": req
    }
    response("success", switch[req["REQUEST_METHOD"]](info))
except Exception as e:
    response("error", e.args[0])
