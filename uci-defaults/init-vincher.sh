#!/bin/sh

# Set Timezone to Asia/Jakarta
uci set system.@system[0].timezone='WIB-7'
uci set system.@system[0].zonename='Asia/Jakarta'

# Set Hostname to VincherWrt
uci set system.@system[0].hostname='VincherWrt'
uci commit system

# Fix luci-app-atinout-mod
chmod +x /usr/bin/luci-app-atinout
chmod +x /sbin/set_at_port.sh

# Fix neofetch Permissions
chmod +x /bin/neofetch

# Add auto clearcache crontabs
chmod +x /sbin/clearcache.sh
echo "0 * * * * /sbin/clearcache.sh" >> /etc/crontabs/root

exit 0
