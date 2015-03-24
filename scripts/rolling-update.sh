#! /bin/bash

set -eu

CTRL_BASENAME=webcontroller
TARGET_COUNT=2
GKE_CMD="gcloud preview container kubectl"

# Some minimal protection against racy deploys
if [ $($GKE_CMD get rc | grep -c $CTRL_BASENAME) -ne 1 ]; then
    echo "More than one replication controller deployed"
    exit 1
fi

OLD_CTRL_VERSION=$($GKE_CMD get rc | grep $CTRL_BASENAME | cut -f1 -d ' ' | sed "s/$CTRL_BASENAME-//")
NEW_CTRL_VERSION=$CIRCLE_SHA1

if [ $OLD_CTRL_VERSION == $NEW_CTRL_VERSION ]; then
    echo "$NEW_CTRL_VERSION is already deployed"
    exit 1
fi

echo "Old version:" $OLD_CTRL_VERSION
echo "New version:" $NEW_CTRL_VERSION

# Assumes CTRL_VERSION
count-running() {
    echo $($GKE_CMD get pods | grep -c "$CTRL_VERSION.*Running")
}

# Assumes CTRL_VERSION
delete-controller() {
    $GKE_CMD stop rc  $CTRL_BASENAME-$CTRL_VERSION > /dev/null
}

# Assumes CTRL_COUNT and CTRL_VERSION
create-controller() {
    CTRL_ID="$CTRL_BASENAME-$CTRL_VERSION" \
      envsubst < kubernetes/web-controller.json.template > web-controller.json
    $GKE_CMD create -f web-controller.json > /dev/null
}

# Assumes CTRL_COUNT, and CTRL_VERSION
update-controller() {
    delete-controller
    create-controller
}


echo "Bringing up new pods..."
CTRL_COUNT=$TARGET_COUNT CTRL_VERSION=$NEW_CTRL_VERSION create-controller

ACTUAL_COUNT=0
for i in {1..20}; do
    ACTUAL_COUNT=$(CTRL_VERSION=$NEW_CTRL_VERSION count-running)
    if [ $ACTUAL_COUNT -eq $TARGET_COUNT ]; then
	break
    fi
    sleep 5
done

if [ $ACTUAL_COUNT -ne $TARGET_COUNT ]; then
    echo "Timed out waiting for new pods"
    exit 1
fi

echo "Shutting down old pods..."
CTRL_COUNT=0 CTRL_VERSION=$OLD_CTRL_VERSION update-controller


ACTUAL_COUNT=$TARGET_COUNT
for i in {1..20}; do
    ACTUAL_COUNT=$(CTRL_VERSION=$OLD_CTRL_VERSION count-running)
    if [ $ACTUAL_COUNT -eq 0 ]; then
	break
    fi
    sleep 5
done

if [ $ACTUAL_COUNT -ne 0 ]; then
    echo "Timed out shutting down old pods"
    exit 1
fi

CTRL_VERSION=$OLD_CTRL_VERSION delete-controller
