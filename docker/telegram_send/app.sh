#!/bin/bash

cat > telegram-send.conf <<EOL
[telegram]
token = ${TG_TOKEN}
chat_id = ${TG_CHAT_ID}
EOL

telegram-send --config telegram-send.conf "${TEXT}"