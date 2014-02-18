#!/bin/bash
CONFIGFILE="/opt/srm/.srm-config"

if [ ! -f $CONFIGFILE ]; then 
    echo "Missing config file at $CONFIGFILE"
    exit 1
else
    . $CONFIGFILE
fi

if [ ! -f $STATEFILE ]; then
    echo "Missing the state file at $STATEFILE"
    exit 1
else
    PREVSTATE=$(cat $STATEFILE)
fi

# change this to a command that applies to your setup
ping -c1 -w1 $HOST || STATE="DOWN"

# just for fun
if [ "$STATE" = "DOWN" ]&&[ "$PREVSTATE" = "DOWN" ]; then
    echo "Previous state was down, current state is down, doing nothing"
fi
if [ "$STATE"  = "UP" ]&&[ "$PREVSTATE" = "UP" ]; then
    echo "Previous state was up, current state is up, doing nothing"
fi

# actually doing something
if [ "$STATE" = "UP" ]&&[ "$PREVSTATE" = "DOWN" ]; then
    echo "Previous state was down, current state is up, notifying of return"
    echo -e "$HOSTN ($HOST) appears to have returned, enjoy\n\n $(ping -c4 $HOST)" | mail -s "$MONITORNAME says $HOSTN is UP" $EMAIL
    echo $STATE > $STATEFILE
fi
if [ "$STATE" = "UP" ]&&[ "$PREVSTATE" = "DOWN0" ]; then
    echo "Previous state was down (no notification), current state is up"
    echo $STATE > $STATEFILE
fi
if [ "$STATE" = "DOWN" ]&&[ "$PREVSTATE" = "UP" ]; then
    echo "Previous state was up, current state is down, recording initial down state (no notification)"
    echo "$STATE"0 > $STATEFILE
fi
if [ "$STATE" = "DOWN" ]&&[ "$PREVSTATE" = "DOWN0" ]; then
    echo "Previous state was down (no notification), current state is still down, notifying of shit"
    echo -e "$HOSTN ($HOST) appears to be down, have a look\n\n $(ping -c4 $HOST)" | mail -s "$MONITORNAME says $HOSTN is DOWN" $EMAIL
    echo $STATE > $STATEFILE
fi
