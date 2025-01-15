#!/bin/sh

mkdir -p /config/redis /config/unbound /config/AdGuardHome || {
    echo "Failed to create directories"
    exit 1
}

if [ -z "$(ls -A /config/redis)" ]; then
    cp -r /config_default/redis/* /config/redis/ || {
        echo "Failed to copy Redis configuration files"
        exit 1
    }
fi

if [ -z "$(ls -A /config/unbound)" ]; then
    cp -r /config_default/unbound/* /config/unbound/ || {
        echo "Failed to copy Unbound configuration files"
        exit 1
    }
fi

if [ -z "$(ls -A /config/AdGuardHome)" ]; then
    cp -r /config_default/AdGuardHome/* /config/AdGuardHome/ || {
        echo "Failed to copy AdGuardHome configuration files"
        exit 1
    }
fi
