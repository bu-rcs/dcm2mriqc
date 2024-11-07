# imports
import requests
import argparse
import sys
import json

# useful functions
def get(url, **kwargs):
    try:
        r = sess.get(url, **kwargs)
        r.raise_for_status()
    except (requests.ConnectionError, requests.exceptions.RequestException) as e:
        print("Request Failed")
        print("    " + str(e))
        sys.exit(1)
    return r

def cleanServer(server):
    server.strip()
    if server[-1] == '/':
        server = server[:-1]
    if server.find('http') == -1:
        server = 'https://' + server
    return server

# parse input arguments
parser = argparse.ArgumentParser(description="Run dcm2niix on every file in a session")
parser.add_argument("--host", default="https://cnda.wustl.edu", help="CNDA host", required=True)
parser.add_argument("--user", help="CNDA username", required=True)
parser.add_argument("--password", help="Password", required=True)
parser.add_argument("--project", help="Project", required=False)

args, unknown_args = parser.parse_known_args()
host = cleanServer(args.host)
project = args.project

# Set up session
sess = requests.Session()
sess.verify = False
sess.auth = (args.user, args.password)

# Get site-level bids config data
bidsmaplist = []
print()
print("Get site-wide BIDS map")
r = sess.get(host + "/data/config/bids/bidsmap", params={"contents": True})
if r.ok:
    bidsmaptoadd = r.json()
else:
    print("Could not read site-wide BIDS map")

# write the bids config file into the container
with open("bids_config.json", "w") as final:
    json.dump(bidsmaptoadd, final, indent=2)