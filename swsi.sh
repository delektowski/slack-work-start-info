USER_NAME=$(grep USER_NAME .env | cut -d '=' -f2)
CHANNEL=$(grep CHANNEL .env | cut -d '=' -f2)
IMG_URL=$(grep IMG_URL .env | cut -d '=' -f2)
SLACK_WEBHOOK=$(grep SLACK_WEBHOOK .env | cut -d '=' -f2)

GET_TEXT() {
  START_TIME=$(date +"%H:%M")
  END_TIME=$(date -v+8H +"%H:%M")
  BREAK_TIME=$(date -v+4H +"%H:%M")
  QUOTE=$(curl -v -i -X GET http://quotes.rest/qod.json\?category\=inspire | sed -n '/ *"quote": *"/ { s///; s/".*//; p; }') &&
    if [ -z "$QUOTE" ]; then
      TEXT="Hej! Dziś zaczynam od: $START_TIME, a kończę o: $END_TIME; Przerwa ok.: $BREAK_TIME"
    else
      TEXT="Hej! Dziś zaczynam od: $START_TIME, a kończę o: $END_TIME; Przerwa ok.: $BREAK_TIME \\n Cytat na dziś: '$QUOTE' "
    fi

  echo "$TEXT"
}

curl -X POST --data-urlencode "payload={\"channel\": $CHANNEL, \"username\": $USER_NAME, \"text\": \"$(GET_TEXT)\", \"icon_url\": $IMG_URL}" "$SLACK_WEBHOOK"
