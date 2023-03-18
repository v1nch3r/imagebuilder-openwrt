#!/bin/sh

clientui_path="/usr/lib/lua/luci/model/cbi/openclash/client.lua"

patching1 () {
    sed -i "s|d = SimpleForm("openclash")|-- d = SimpleForm("openclash")|g" ${clientui_path}
    sed -i "s|d.title = translate("Credits")|-- d.title = translate("Credits")|g" ${clientui_path}
    sed -i "s|d.reset = false|-- d.reset = false|g" ${clientui_path}
    sed -i "s|d.submit = false|-- d.submit = false|g" ${clientui_path}
    sed -i "s|d:section(SimpleSection).template  = "openclash/developer"|-- d:section(SimpleSection).template  = "openclash/developer"|g" ${clientui_path}
}

patching2 () {
    sed -i "s|dler = SimpleForm("openclash")|-- dler = SimpleForm("openclash")|g" ${clientui_path}
    sed -i "s|dler.reset = false|-- dler.reset = false|g" ${clientui_path}
    sed -i "s|dler.submit = false|-- dler.submit = false|g" ${clientui_path}
    sed -i "s|dler:section(SimpleSection).template  = "openclash/dlercloud"|-- dler:section(SimpleSection).template  = "openclash/dlercloud"|g" ${clientui_path}
}

exit 0


