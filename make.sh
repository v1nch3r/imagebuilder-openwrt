#!/bin/sh

make_path="$(pwd)"
openwrt_dir="openwrt"
imagebuilder_path="${make_path}/${openwrt_dir}"
releases="21.02.1"
targets="armvirt"
imagebuilder_repo="https://downloads.immortalwrt.org/releases/${releases}/targets/${targets}/64/immortalwrt-imagebuilder-${releases}-${targets}-64.Linux-x86_64.tar.xz"
luci_app_openclash="https://github.com/vernesong/OpenClash/releases/download/v0.45.59-beta/luci-app-openclash_0.45.59-beta_all.ipk"
luci_app_netmon="https://github.com/helmiau/helmiwrt-packages/releases/download/ipk/luci-app-netmon_1.3_all.ipk"
luci_app_shutdown="https://github.com/helmiau/helmiwrt-packages/releases/download/ipk/luci-app-shutdown_1.3_all.ipk"

download_imagebuilder () {
    wget ${imagebuilder_repo}
    tar -xJf immortalwrt-imagebuilder-* && rm -f immortalwrt-imagebuilder-*.tar.xz
    mv -f immortalwrt-imagebuilder-* ${openwrt_dir}
}

custom_packages () {
    wget -P ${imagebuilder_path}/packages/ ${luci_app_openclash}
    wget -P ${imagebuilder_path}/packages/ ${luci_app_netmon}
    wget -P ${imagebuilder_path}/packages/ ${luci_app_shutdown}
    ls -a ${imagebuilder_path}/packages/
}

custom_packages
download_imagebuilder

exit 0
