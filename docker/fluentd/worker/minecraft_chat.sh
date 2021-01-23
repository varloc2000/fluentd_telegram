#!/bin/sh

# Process telegram log
# Example: "[07:16:49] [Server thread/INFO]: <varloc2000> miners! Hello this is my message to telegram!"

while IFS='' read -r line
do
  time="${line#*[}"
  time="${time%%]*}"

  username="${line%%>*}"
  username="${username#*<}"

  chat_message="${line#*miners!}"

  message="[$time GMT] Сообщение из игры от $username: $chat_message."

  #echo "$message" >> "/fluentd/log/debug.csv"

  /bin/worker/_telegram_send.sh "$message"
done < $1
