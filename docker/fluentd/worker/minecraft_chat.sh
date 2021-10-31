#!/bin/sh

# Process chat message fluentd tag (Eg: row.minecraft.telegram.<{username}>.[{time}].miners!{message}
# Example: row.minecraft.telegram.<varloc2000>.[18:07:23].miners! Починил сообщения. Можно отправлять из чата игры используя miners! вначале сообщения

while IFS='' read -r line
do
  time="${line%%].*}" # cut longest match of ].* from the right
  time="${time##*.[}" # cut longest match of .[* from the left

  username="${line%%>.[*}" # cut longest match of .[* from the right
  username="${username#*.<}" # cut shortest match of *. from the left

  chat_message="${line#*].}" # cut shortest match of *]. from the left

  message="[$time GMT] Сообщение из игры от $username: $chat_message."

  #echo "$message" >> "/fluentd/log/debug.csv"

  /bin/worker/_telegram_send.sh "$message"
done < $1
