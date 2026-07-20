#!/bin/sh
# Alias: run the FMD plan checker from any working directory.
# Usage: ./check-plan.sh [--strict]
exec python3 "$(dirname "$0")/fmd/tools/check-implementation-plan.py" docs/implementation-plan.md "$@"
