#!/bin/sh

# Process advancement log
# Example: "[07:16:49] [Server thread/INFO]: <varloc2000> has made the advancement [Not Today, Thank You]"

while IFS='' read -r line
do
  username="${line%%>*}"
  username="${username#*<}"

  advancement="${line##*[}"
  advancement="${advancement%]}"

  message="$username получил достижение '$advancement'"

  #echo "$message" >> "/fluentd/log/debug.csv"

  /bin/worker/_telegram_send.sh "$message"
done < $1
