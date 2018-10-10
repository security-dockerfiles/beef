#!/bin/sh

RANDOM_BEEF_PASSWORD=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 32)
DEFAULT_BEEF_USER="beef"

CHOSEN_BEEF_PASSWORD=$RANDOM_BEEF_PASSWORD
CHOSEN_BEEF_USER=$DEFAULT_BEEF_USER

if [ $BEEF_PASSWORD ]; then
    sed -i "s/passwd: \"beef\"/passwd: \"$BEEF_PASSWORD\"/" config.yaml
    CHOSEN_BEEF_PASSWORD=$BEEF_PASSWORD
else
    sed -i "s/passwd: \"beef\"/passwd: \"$RANDOM_BEEF_PASSWORD\"/" config.yaml
fi

if [ $BEEF_USER ]; then
    sed -i "s/user: \"beef\"/user: \"$BEEF_USER\"/" config.yaml
    CHOSEN_BEEF_USER=$BEEF_USER
fi

echo "Beef credentials: $CHOSEN_BEEF_USER:$CHOSEN_BEEF_PASSWORD"
CHOSEN_BEEF_PASSWORD=""

exec ./beef "$@"
