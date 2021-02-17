#!/bin/bash
parent_path=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)

USER_NAME=$(cd "$parent_path" && grep USER_NAME .env | cut -d '=' -f2)
CHANNEL=$(cd "$parent_path" && grep CHANNEL .env | cut -d '=' -f2)
IMG_URL=$(cd "$parent_path" && grep IMG_URL .env | cut -d '=' -f2)
SLACK_WEBHOOK=$(cd "$parent_path" && grep SLACK_WEBHOOK .env | cut -d '=' -f2)

wget -O output.json 'https://www.thecocktaildb.com/api/json/v1/1/random.php'

GET_TEXT() {
  START_TIME=$(date +"%H:%M")
  END_TIME=$(date -v+8H +"%H:%M")
  BREAK_TIME=$(date -v+4H +"%H:%M")

  INGREDIENTS=$(cd "$parent_path" && python -m json.tool output.json | grep -F 'strIngredient' | cut -d":" -f2- | grep -v 'null' | sed -e 's|["'\'']||g' | tr '\n' ' ' | sed 's/.$//')

  INSTRUCTIONS=$(cd "$parent_path" && python -m json.tool output.json | grep -w 'strInstructions' | cut -d":" -f2- | grep -v 'null' | sed -e 's|["'\'']||g' | tr '\n' ' ')

  DRINK_NAME=$(cd "$parent_path" && python -m json.tool output.json | grep -w 'strDrink' | cut -d":" -f2- | grep -v 'null' | sed -e 's|["'\'']||g' | tr '\n' ' ' | tr -d ',')

  if [ -z "$INGREDIENTS" ]; then
    TEXT="Dziś zaczynam od: $START_TIME, a kończę o: $END_TIME; Przerwa ok.: $BREAK_TIME"
  else
    TEXT="Hej! Dziś *zaczynam od:* $START_TIME, a *kończę o:* $END_TIME; *Przerwa ok.:* $BREAK_TIME \\n *Today's Drink Of The Day:* $DRINK_NAME \\n *Ingredients:* $(echo $INGREDIENTS | sed 's/.$//')  \\n *Instruction:* $(echo $INSTRUCTIONS | sed 's/.$//') "
  fi

  echo "$TEXT"
}

GET_THUMB_IMG() {
    DRINK_THUMB_IMG=$(cd "$parent_path" && python -m json.tool output.json | grep -w 'strDrinkThumb' | cut -d":" -f2- | grep -v 'null' | sed -e 's|["'\'']||g' | tr '\n' ' ' | tr -d ',')
    
    echo $DRINK_THUMB_IMG
}

curl -X POST --data-urlencode "payload={\"channel\": $CHANNEL, \"username\": $USER_NAME,\"blocks\": [
		{
			\"type\": \"section\",
			\"text\": {
				\"type\": \"mrkdwn\",
				\"text\": \"$(GET_TEXT)\"
			},
			\"accessory\": {
				\"type\": \"image\",
				\"image_url\": \"$(GET_THUMB_IMG)\",
				\"alt_text\": \"cute cat\"
			}
		}
	],
\"icon_url\": $IMG_URL}" "$SLACK_WEBHOOK"

cd "$parent_path" && rm output.json
