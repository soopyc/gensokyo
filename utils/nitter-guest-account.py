# nitter-guest-account.py
# cross-platform port of https://github.com/zedeus/nitter/issues/983#issuecomment-1681199357
# thank you!
import sys
import json
from base64 import b64encode
from argparse import ArgumentParser

try:
	import requests
except ImportError:
	print("\x1b[31m[!] Could not import `requests`.")
	print("\x1b[31m[!] This script requires the requests module to be installed.")
	print("\x1b[31m[!] We apologize but using plain http.client is way too painful."
          " Please reach out with a PR if you would like to change that!")
	sys.exit(1)

verbose = False
noprettyprint = False

# Constants
CONSUMER_KEY = "3nVuSoBZnx6U4vzUxf5w"
CONSUMER_SECRET = "Bcs59EFbbsdF6Sl9Ng71smgStWEGwXXKSjYvPVt7qys"
EXPECTED_BEARER_TOKEN = "Bearer AAAAAAAAAAAAAAAAAAAAAFXzAwAAAAAAMHCxpeSDG1gLNLghVe8d74hl6k4%3DRUMF4xAQLsbeBhTSRrCiQpJtxoGWeyHrDb5te2jpGskWDFW82F"
BASE_REQUEST_HEADERS = {
		'Content-Type': 'application/json',
		'User-Agent': 'TwitterAndroid/9.95.0-release.0 (29950000-r-0) ONEPLUS+A3010/9 (OnePlus;ONEPLUS+A3010;OnePlus;OnePlus3;0;;1;2016)',
		'X-Twitter-API-Version': '5',
		'X-Twitter-Client': 'TwitterAndroid',
		'X-Twitter-Client-Version': '9.95.0-release.0',
		'OS-Version': '28',
		'System-User-Agent': 'Dalvik/2.1.0 (Linux; U; Android 9; ONEPLUS A3010 Build/PKQ1.181203.001)',
		'X-Twitter-Active-User': 'yes',
}

BASE_URL = "https://api.twitter.com"
BEARER_TOKEN_ENDPOINT = "/oauth2/token"
GUEST_TOKEN_ENDPOINT = "/1.1/guest/activate.json"
FLOW_TOKEN_ENDPOINT = "/1.1/onboarding/task.json?flow_name=welcome&api_version=1&known_device_token=&sim_country_code=us"
TASKS_ENDPOINT = "/1.1/onboarding/task.json"

def send_req(method, endpoint, **kwargs) -> requests.Response:
	debug(f"attempting `{endpoint}`")
	try:
		res = requests.request(method, BASE_URL + endpoint, **kwargs)
		res.raise_for_status()
	except requests.HTTPError:
		error("HTTP request failed (non 2xx), unable to proceed.")
		error('Please try again in a bit')
		debug(f"request headers => {res.request.headers}")
		debug(f"response headers => {res.headers}")
		debug(f'response body => {res.content}')
		sys.exit(1)
	except Exception:
		error(f"an unhandled error while sending a request to {endpoint} occurred")
		raise

	debug(f'got response body {res.content}')
	return res

B_SUBTASK_VERSIONS = {
	"generic_urt": 3,
	"standard": 1,
	"open_home_timeline": 1,
	"app_locale_update": 1,
	"enter_date": 1,
	"email_verification": 3,
	"enter_password": 5,
	"enter_text": 5,
	"one_tap": 2,
	"cta": 7,
	"single_sign_on": 1,
	"fetch_persisted_data": 1,
	"enter_username": 3,
	"web_modal": 2,
	"fetch_temporary_password": 1,
	"menu_dialog": 1,
	"sign_up_review": 5,
	"interest_picker": 4,
	"user_recommendations_urt": 3,
	"in_app_notification": 1,
	"sign_up": 2,
	"typeahead_search": 1,
	"user_recommendations_list": 4,
	"cta_inline": 1,
	"contacts_live_sync_permission_prompt": 3,
	"choice_selection": 5,
	"js_instrumentation": 1,
	"alert_dialog_suppress_client_events": 1,
	"privacy_options": 1,
	"topics_selector": 1,
	"wait_spinner": 3,
	"tweet_selection_urt": 1,
	"end_flow": 1,
	"settings_list": 7,
	"open_external_link": 1,
	"phone_verification": 5,
	"security_key": 3,
	"select_banner": 2,
	"upload_media": 1,
	"web": 2,
	"alert_dialog": 1,
	"open_account": 2,
	"action_list": 2,
	"enter_phone": 2,
	"open_link": 1,
	"show_code": 1,
	"update_users": 1,
	"check_logged_in_account": 1,
	"enter_email": 2,
	"select_avatar": 4,
	"location_permission_prompt": 2,
	"notifications_permission_prompt": 4
}

def get_flow_token_body():
	return {
		"flow_token": None,
		"input_flow_data": {
			"country_code": None,
			"flow_context": {
				"start_location": {
					"location": "splash_screen"
				}
			},
			"requested_variant": None,
			"target_user_id": 0
		},
		"subtask_versions": B_SUBTASK_VERSIONS
	}

def get_tasks_body(flow_token: str) -> dict:
	return {
		"flow_token": flow_token,
		"subtask_inputs": [{
			"open_link": {
				"link": "next_link"
			},
			"subtask_id": "NextTaskOpenLink"
		}],
		"subtask_versions": B_SUBTASK_VERSIONS
	}

# Functions
def format_json(msg, object) -> str:
	return json.dumps(object, indent=None if noprettyprint else 4)

def debug(msg, *arg, **kwarg) -> None:
	global verbose
	if verbose:
		print("\x1b[37m[*]", msg, *arg, "\x1b[0m", file=sys.stderr, **kwarg)

def info(msg, *arg, **kwarg) -> None:
	print("\x1b[34m[i]", msg, *arg, "\x1b[0m", file=sys.stderr, **kwarg)


def success(msg, *arg, **kwarg) -> None:
	print("\x1b[32m[i]", msg, *arg, "\x1b[0m", file=sys.stderr, **kwarg)


def warn(msg, *arg, **kwarg) -> None:
	print("\x1b[33m[!]", msg, *arg, "\x1b[0m", file=sys.stderr, **kwarg)


def error(msg, *arg, **kwarg) -> None:
	print("\x1b[31m[x]", msg, *arg, "\x1b[0m", file=sys.stderr, **kwarg)

# Arguments
parser = ArgumentParser()
parser.add_argument('-v', '--verbose', action='store_true', help="be more noisy")
parser.add_argument('-P', '--no-pretty', action='store_true', help="disable pretty-printing of json data")
parser.add_argument(
	'outfile',
	nargs="?",
	default="-",
	help="the json output file to put/append received account data to."
)


def main() -> int:
	global verbose
	args = parser.parse_args()
	verbose = args.verbose

	info("nitter-guest-account.py (2023-08-25)")
	info("This is free software: you are free to change and redistribute it, under the terms of the Apache-2.0 license")
	info("There is NO WARRANTY, to the extent permitted by law.")

	info("Fetching bearer token...")
	bt_raw = send_req('post', BEARER_TOKEN_ENDPOINT,
		auth=requests.auth.HTTPBasicAuth(CONSUMER_KEY, CONSUMER_SECRET),
		data={'grant_type': "client_credentials"}
	).json()
	bearer_token = ' '.join(bt_raw.values())
	if bearer_token.lower() != EXPECTED_BEARER_TOKEN.lower():
		warn('Received bearer token does not match expected value. Continuing anyways, but beware of errors.')
		info(f'bearer token => {bearer_token}')
	else:
		success('Received bearer token matches expected value.')

	info("Fetching guest token...")
	guest_token = send_req('post', GUEST_TOKEN_ENDPOINT, headers={'Authorization': bearer_token}).json()['guest_token']
	success(f'guest token => {guest_token}')

	debug('updating header with acquried credentials')
	request_headers = BASE_REQUEST_HEADERS.copy()
	request_headers.update({
		"authorization": bearer_token,
		"X-Guest-Token": guest_token
	})

	info('Fetching flow token...')
	flow_token = send_req('post', FLOW_TOKEN_ENDPOINT, headers=request_headers, json=get_flow_token_body()).json()['flow_token']
	success(f'flow token => {flow_token}')

	info('Fetching final account object...')
	tasks = send_req('post', TASKS_ENDPOINT, headers=request_headers, json=get_tasks_body(flow_token))
	info(tasks.json())

	return 0


if __name__ == "__main__":
	rc = main()
	sys.exit(rc)
