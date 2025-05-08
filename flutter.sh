#!/bin/bash

[ "$(whoami)" != "root" ] && exit 1

if ! fvm list | grep -q "●" 2>/dev/null; then
    echo "No version found, falling back to $FLUTTER_VERSION"
    fvm use -f "$FLUTTER_VERSION"
fi

exec fvm flutter "$@"