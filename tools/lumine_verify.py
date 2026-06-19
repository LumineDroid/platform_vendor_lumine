#!/usr/bin/env python3
"""
LumineDroid device verification script.
"""

import json
import sys
import argparse


def load_devices(path: str) -> list[dict]:
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"ERROR: devices.json not found at '{path}'", file=sys.stderr)
        sys.exit(2)
    except json.JSONDecodeError as e:
        print(f"ERROR: Failed to parse devices.json: {e}", file=sys.stderr)
        sys.exit(2)

    devices = []
    if isinstance(data, dict):
        for entries in data.values():
            if isinstance(entries, list):
                devices.extend(entries)
    elif isinstance(data, list):
        for entries in data:
            if isinstance(entries, list):
                devices.extend(entries)
            elif isinstance(entries, dict):
                devices.append(entries)

    return devices


def find_device(devices: list[dict], codename: str) -> dict | None:
    for device in devices:
        if device.get("codename") == codename:
            return device
    return None


def main():
    parser = argparse.ArgumentParser(description="LumineDroid official device verifier")
    parser.add_argument("--devices",     required=True, help="Path to devices.json")
    parser.add_argument("--product",     required=True, help="TARGET_PRODUCT (device codename)")
    parser.add_argument("--maintainer",  required=True, help="LUMINE_MAINTAINER value from environment")
    args = parser.parse_args()

    devices = load_devices(args.devices)
    device  = find_device(devices, args.product)

    if device is None:
        print(f"{args.product}: Not found in official list", file=sys.stderr)
        print("LUMINE_BUILD_TYPE=UNOFFICIAL")
        print("LUMINE_MAINTAINER_LINK=")
        sys.exit(1)

    official_maintainer = device.get("maintainer", "")
    telegram_link       = device.get("telegram", "")

    if official_maintainer == args.maintainer:
        print(
            f"{args.product}: OFFICIAL - Maintainer verified ({args.maintainer})",
            file=sys.stderr,
        )
        print("LUMINE_BUILD_TYPE=OFFICIAL")
        print(f"LUMINE_MAINTAINER_LINK={telegram_link}")
        sys.exit(0)
    else:
        print(f"{args.product}: OFFICIAL device, but maintainer mismatch", file=sys.stderr)
        print(f"Expected: {official_maintainer}, Got: {args.maintainer}",   file=sys.stderr)
        print("LUMINE_BUILD_TYPE=UNOFFICIAL")
        print("LUMINE_MAINTAINER_LINK=")
        sys.exit(1)


if __name__ == "__main__":
    main()
