#!/bin/sh

# Set Timezone to Asia/Jakarta
uci set system.@system[0].timezone='WIB-7'
uci set system.@system[0].zonename='Asia/Jakarta'
uci commit system

# Fix luci-app-atinout-mod
chmod +x /usr/bin/luci-app-atinout
chmod +x /sbin/set_at_port.sh

exit 0