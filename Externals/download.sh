#!/bin/sh -e

REACHABILITY_VERSION="3.1.0"

cd "`dirname $0`"

if [ ! -f "Reachability/VERSION" ] || [ "`cat Reachability/VERSION`" != "$REACHABILITY_VERSION" ]
then
  # https://github.com/tonymillion/Reachability/tags
  echo "Downloading Reachability $REACHABILITY_VERSION"
  rm -rf "Reachability-$REACHABILITY_VERSION.tar.gz" "Reachability-$REACHABILITY_VERSION" "Reachability"
  curl -s -L -o "Reachability-$REACHABILITY_VERSION.tar.gz" "https://github.com/tonymillion/Reachability/archive/v$REACHABILITY_VERSION.tar.gz"
  tar xf "Reachability-$REACHABILITY_VERSION.tar.gz"
  mv "Reachability-$REACHABILITY_VERSION" "Reachability"
  rm -rf "Reachability-$REACHABILITY_VERSION.tar.gz"
  echo "$REACHABILITY_VERSION" > "Reachability/VERSION"
fi
