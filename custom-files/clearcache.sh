#!/bin/sh

clearcache () {
    sync
    echo 3 > /proc/sys/vm/drop_caches 
}

additional () {
    rm -rf /tmp/luci*
}

clearcache
additional
echo "cleared..."

exit 0