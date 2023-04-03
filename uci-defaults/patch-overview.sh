#!/bin/sh

path="/usr/lib/lua/luci/view/admin_status/index.htm"

patching () {
    sed -i "9d" ${path}
    sed -i "9i <!-- <h2 name=content><%:Status%></h2> -->" ${path}
}

patching_done () {
    echo "patching done...."
}

patching
patching_done

exit 0