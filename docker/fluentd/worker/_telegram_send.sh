#!/bin/sh

# Send Telegram notification using another docker container with telegram-send cli tool

docker run --env-file /bin/worker/env.list -e TEXT="$1" dodomi_telegram_send