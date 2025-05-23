#!/bin/sh

set -e

# Create necessary directories
mkdir -p /config/valkey /config/unbound /config/AdGuardHome /opt/adguardhome/work /usr/local/etc/unbound /run/unbound
chown -R unbound:unbound /usr/local/etc/unbound /run/unbound
chmod 755 /opt/adguardhome/work

# Copy Valkey configuration if not present
if [ -z "$(ls -A /config/valkey)" ]; then
    cp -r /config_default/valkey/* /config/valkey/
fi

# Copy Unbound configuration if not present
if [ -z "$(ls -A /config/unbound)" ]; then
    cp -r /config_default/unbound/* /config/unbound/
fi

# Create symbolic link for Unbound configuration
ln -sf /config/unbound/unbound.conf /usr/local/etc/unbound/unbound.conf

# Copy AdGuardHome configuration if not present
if [ -z "$(ls -A /config/AdGuardHome)" ]; then
    cp -r /config_default/AdGuardHome/* /config/AdGuardHome/
fi
