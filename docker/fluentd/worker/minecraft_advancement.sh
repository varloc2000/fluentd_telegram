#!/bin/sh

# Process advancement fluentd tag (Eg: row.minecraft.advancement.{username}.[{advanceent}]
# Example: row.minecraft.advancement.masha.[Free the End]

while IFS='' read -r line
do
  username="${line%.[*}" # cut shortest match of .[* from the right
  username="${username#*.}" # cut shortest match of *. from the left
  username="${username#*.}" # cut shortest match of *. from the left
  username="${username#*.}" # cut shortest match of *. from the left

  advancement="${line##*[}" # cut longest match of *[ from the left
  advancement="${advancement%]}" # cut shortest match of ] from the right

  message="$username получил достижение '$advancement'"

  #echo "$message" >> "/fluentd/log/debug.csv"

  /bin/worker/_telegram_send.sh "$message"
done < $1
