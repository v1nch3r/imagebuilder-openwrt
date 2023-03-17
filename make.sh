#!/bin/sh
#==========================================================

# config path
make_path="$(pwd)"
openwrt_dir="openwrt"
imagebuilder_path="${make_path}/${openwrt_dir}"

# targets
releases="21.02.1"
targets="armvirt"

# config repo
imagebuilder_repo="https://downloads.immortalwrt.org/releases/${releases}/targets/${targets}/64/immortalwrt-imagebuilder-${releases}-${targets}-64.Linux-x86_64.tar.xz"
luci_app_openclash="https://github.com/vernesong/OpenClash/releases/download/v0.45.59-beta/luci-app-openclash_0.45.59-beta_all.ipk"
luci_app_netmon="https://github.com/helmiau/helmiwrt-packages/releases/download/ipk/luci-app-netmon_1.3_all.ipk"
luci_app_shutdown="https://github.com/helmiau/helmiwrt-packages/releases/download/ipk/luci-app-shutdown_1.3_all.ipk"

# config package
my_packages="-luci-app-cpufreq -luci-app-turboacc -luci-app-filetransfer luci-theme-material luci-theme-argon luci-app-argon-config luci-app-ttyd luci-app-openclash luci-app-passwall luci-app-shutdown luci-app-netmonitor luci-app-zerotier nano htop openssh-sftp-server kmod-usb-net-cdc-ether usb-modeswitch comgt-ncm kmod-usb-net-huawei-cdc-ncm coreutils-nohup bash iptables dnsmasq-full curl ca-certificates ipset ip-full iptables-mod-tproxy iptables-mod-extra libcap libcap-bin ruby ruby-yaml kmod-tun kmod-inet-diag unzip luci-compat luci luci-base"

download_imagebuilder () {
    wget ${imagebuilder_repo}
    tar -xJf immortalwrt-imagebuilder-* && rm -f immortalwrt-imagebuilder-*.tar.xz
    mv -f immortalwrt-imagebuilder-* ${openwrt_dir}
}

custom_packages () {
    wget -P ${imagebuilder_path}/packages/ ${luci_app_openclash}
    wget -P ${imagebuilder_path}/packages/ ${luci_app_netmon}
    wget -P ${imagebuilder_path}/packages/ ${luci_app_shutdown}
}

build_rootfs () {
    cd ${imagebuilder_path}
    make image PROFILE="Default" PACKAGES="${my_packages}" FILES="files"
}

download_imagebuilder
custom_packages
build_rootfs

exit 0
