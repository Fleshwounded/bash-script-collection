#!/bin/bash

# How to install twurl
# $ apt-get install ruby-full
# $ gem install twurl

# Put text files with tweet text in $TWEET_DIR and images for tweets in $IMG_DIR
# then put this file either into your crontab or run manually

if [[ -z "$TWEET_DIR" ]]; then
echo "$TWEET_DIR exists"; 
else
mkdir -p $TWEET_DIR;
fi

TWEET_DIR="/home/fleshwounded/Tweets"
IMG_DIR="/home/fleshwounded/Pictures"
LOG_FILE="/tmp/getaphrase_log.log"
CHOSEN_IMG=$(find "$IMG_DIR" -type f | shuf -n 1)
CHOOSE_TWEET=$(find $TWEET_DIR -type f | shuf -n 1)
TWEET_STATUS=`cat $CHOOSE_TWEET`

if [[ -z "$CHOSEN_IMG" ]]; then
        echo "[$(date)] No images to tweet" >> "$LOG_FILE"
else
        IMAGE_FN=$(basename "$CHOSEN_IMG")
        MEDIA_ID=$(twurl -H upload.twitter.com -X POST "/1.1/media/upload.json" --file "$CHOSEN_IMG" --file-field "media" | jq -r '.media_id_string')
        if ! [[ -z "$MEDIA_ID" ]]; then
                RESULT=$(twurl "/1.1/statuses/update.json" -d "media_ids=$MEDIA_ID&status=$TWEET_STATUS" | jq -r '.created_at')
                if [[ $RESULT == "null" ]]; then
                        echo "[$(date)] (!!) Failed to tweet $IMAGE_FN, was not posted" >> "$LOG_FILE"
                else
                        #rm -R -f $CHOSEN_IMG
                        echo "[$(date)] Tweeted $IMAGE_FN" >> "$LOG_FILE"
                fi
        else
                echo "[$(date)] (!!) Failed to tweet $IMAGE_FN, no media ID given" >> "$LOG_FILE"
        fi
fi
