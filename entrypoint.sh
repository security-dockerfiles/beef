#!/bin/sh

RANDOM_BEEF_PASSWORD=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 32)
DEFAULT_BEEF_USER="beef"

CHOSEN_BEEF_PASSWORD=$RANDOM_BEEF_PASSWORD
CHOSEN_BEEF_USER=$DEFAULT_BEEF_USER

CURRENT_PWD=$(grep -oEi 'passwd\: \"(.*?)\"' config.yaml | cut -d'"' -f2)

if [ $BEEF_PASSWORD ]; then
    # explicit password was given, use it instead of random
    CHOSEN_BEEF_PASSWORD=$BEEF_PASSWORD
else
    if [ "$CURRENT_PWD" = "beef" ]; then
        # config still contains the default password so change it for a random one
        CHOSEN_BEEF_PASSWORD=$RANDOM_BEEF_PASSWORD
    else
        # config was already changed with a random password, so don't change it!
        CHOSEN_BEEF_PASSWORD=$CURRENT_PWD
    fi;
fi
# replace anything already set, by chosen or random password
sed -i "s/passwd: .*/passwd: \"$CHOSEN_BEEF_PASSWORD\"/" config.yaml

if [ $BEEF_USER ]; then
    # explicit user was given, replace anything currently set
    sed -i "s/user: .*/user: \"$BEEF_USER\"/" config.yaml
    CHOSEN_BEEF_USER=$BEEF_USER
fi

echo "Beef credentials: $CHOSEN_BEEF_USER:$CHOSEN_BEEF_PASSWORD"
CHOSEN_BEEF_PASSWORD=""

exec ./beef "$@"
