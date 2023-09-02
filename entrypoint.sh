#!/bin/bash
set -e

rm -f /lookfor1/tmp/pids/server.pid

exec "$@"
