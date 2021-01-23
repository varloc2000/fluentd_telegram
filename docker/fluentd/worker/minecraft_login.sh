#!/bin/sh

# Process login and logout fluentd tag (Eg: row.minecraft.login.{username}, row.minecraft.logout.{username})
# Example: row.minecraft.login.masha

while IFS='' read -r col1
do
  username="${col1##*.}"

  action="${col1%.*}"
  action="${action##*.}"

  case $action in
    'login')
      message="$username присоединился к игре"
      ;;
    'logout')
      message="$username вышел из игры"
      ;;
    *)
      exit 0
      ;;
  esac

  #echo "$message" >> "/fluentd/log/debug.csv"

  /bin/worker/_telegram_send.sh "$message"
done < $1
