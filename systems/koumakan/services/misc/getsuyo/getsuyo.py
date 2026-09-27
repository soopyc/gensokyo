#!/usr/bin/env python3
import datetime
import os
import random
import sys
from pathlib import Path
from typing import Any
from zoneinfo import ZoneInfo

import icalendar
import requests

ICS_URL = "https://www.1823.gov.hk/common/ical/en.ics"


def lottery(chance: int):
	"""
	:param chance: one in x chance
	"""
	return random.randrange(chance) == random.randrange(chance)


def prepare_message(
	dt: datetime.datetime,
	url: str,
	description: str,
	prepended_message: str | None = None,
	additional_footer: list[str] | None = None,
):
	components: list[dict[str, Any]] = [  # pyright: ignore[reportExplicitAny]: discord sucking is not my fault
		{"type": 12, "items": [{"media": {"url": url}, "description": description}]},
		{
			"type": 10,
			"content": "・".join(
				[
					f"-# Generated <t:{round(dt.timestamp())}:S>",
					*(additional_footer or []),
					"[Credits](https://assets.soopy.moe/gtck/credits.txt)",
					"[Code](https://patchy.soopy.moe/soopyc/gensokyo/src/branch/main/systems/koumakan/services/misc/getsuyo)",
				]
			),
		},
	]
	if prepended_message:
		components.insert(0, {"type": 10, "content": prepended_message})
	return {
		"username": "【仮】月曜が近いよbot v2.0",
		"avatar_url": "https://assets.soopy.moe/gtck/avatar.jpg",
		"flags": 1 << 15,
		"components": components,
	}


def main():
	# check and load credentials
	if not (dir := os.environ.get("CREDENTIALS_DIRECTORY")):
		print("ERROR: $CREDENTIALS_DIRECTORY is not set. Required credentials: discord-webhook-url")
		return 1
	discord_webhook_url_file = Path(dir) / "discord-webhook-url"
	try:
		with discord_webhook_url_file.open() as f:
			discord_webhook_url = f.read().strip()
	except Exception:
		print("ERROR: cannot read credential 'discord-webhook-url`, please make sure it exists.")
		raise

	now = datetime.datetime.now(tz=ZoneInfo("Etc/GMT-8"))
	if now.weekday() == 1:  # tuesday
		if not lottery(366):
			print("INFO: lost lottery on tuesday. oh no!")
			return 0
		message = prepare_message(
			now,
			"https://assets.soopy.moe/gtck/suiyou.mp4",
			"suiyou ga chikai yo",
			additional_footer=["Special! [1/366 (0.27322%)]"],
		)
	elif now.weekday() == 6:  # sunday
		res = requests.get(ICS_URL)
		res.raise_for_status()
		ics = icalendar.Calendar.from_ical(res.text)

		if event := next(filter(lambda ev: ev.start == (now.date() + datetime.timedelta(days=1)), ics.events), None):
			description = event.summary.ical_value.strip() if type(event.summary) == icalendar.vText else "不明な祝日"  # pyright: ignore[reportAny]: no workarounds!
			msg = f"明日は||{description}||でsu！"

			# more stats
			holidays_this_year = len([_ for _ in filter(lambda ev: ev.start.year == now.year, ics.events)])
			prob = 1 / 7 * holidays_this_year / 365.25
			if lottery(67):
				message = prepare_message(
					now,
					"https://assets.soopy.moe/gtck/shukujitsu-special-1.mp4",
					"shukujitsu dayo~",
					prepended_message=msg,
					additional_footer=[f"~{prob * 100:.5f}%", f"Special! [1/67 => ~{prob * 1 / 67 * 100:.5f}]"],
				)
			else:
				message = prepare_message(
					now,
					"https://assets.soopy.moe/gtck/shukujitsu.mp4",
					"shukujitsu dayo~",
					prepended_message=msg,
					additional_footer=[f"~{prob * 100:.5f}%"],
				)

		else:
			if lottery(311):
				message = prepare_message(
					now,
					"https://assets.soopy.moe/gtck/chikaiyo-special-1.mp4",
					"getsuyo ga chikai yo",
					additional_footer=["Special! [1/311 (0.32154%)]"],
				)
			else:
				message = prepare_message(now, "https://assets.soopy.moe/gtck/chikaiyo.mp4", "getsuyo ga chikai yo")
	else:
		print("WARN: today is neither a Sunday or a Tuesday, not running.")
		return 0

	requests.post(
		discord_webhook_url, params={"wait": "true", "with_components": "true"}, json=message
	).raise_for_status()


if __name__ == "__main__":
	sys.exit(main())
