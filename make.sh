#!/bin/sh
#==========================================================

# config path
make_path="$(pwd)"
openwrt_dir="openwrt"
imagebuilder_path="${make_path}/${openwrt_dir}"
bootfs_dir="BOOTFS"
rootfs_dir="ROOTFS"
bootfs_path="${make_path}/${bootfs_dir}"
rootfs_path="${make_path}/${rootfs_dir}"


# targets
releases="21.02.1"
targets="armvirt"
amlogic="s905x"
kernel="6.0.5-flippy-78+"

# config repo
imagebuilder_repo="https://downloads.immortalwrt.org/releases/${releases}/targets/${targets}/64/immortalwrt-imagebuilder-${releases}-${targets}-64.Linux-x86_64.tar.xz"
bootloader_repo="https://raw.githubusercontent.com/ophub/amlogic-s9xxx-armbian/main/build-armbian/u-boot/amlogic/overload/u-boot-p212.bin"
boot_repo="https://github.com/vincherofficial/kernel/releases/download/${kernel}/boot-${kernel}.tar.gz"
dtb_repo="https://github.com/vincherofficial/kernel/releases/download/${kernel}/dtb-amlogic-${kernel}.tar.gz"
modules_repo="https://github.com/vincherofficial/kernel/releases/download/${kernel}/modules-${kernel}.tar.gz"
luci_app_openclash="https://github.com/vernesong/OpenClash/releases/download/v0.45.59-beta/luci-app-openclash_0.45.59-beta_all.ipk"
luci_app_netmon="https://github.com/helmiau/helmiwrt-packages/releases/download/ipk/luci-app-netmon_1.3_all.ipk"
luci_app_shutdown="https://github.com/helmiau/helmiwrt-packages/releases/download/ipk/luci-app-shutdown_1.3_all.ipk"
luci_app_tinyfm="https://github.com/helmiau/helmiwrt-packages/releases/download/ipk/luci-app-tinyfm_2.5_all.ipk"

# config package
my_packages="-luci-app-cpufreq -luci-app-turboacc -luci-app-filetransfer luci-theme-material luci-theme-argon luci-app-argon-config luci-app-ttyd luci-app-openclash luci-app-passwall luci-app-shutdown luci-app-netmon luci-app-zerotier nano htop openssh-sftp-server kmod-usb-net-cdc-ether usb-modeswitch comgt-ncm kmod-usb-net-huawei-cdc-ncm coreutils-nohup bash iptables dnsmasq-full curl ca-certificates ipset ip-full iptables-mod-tproxy iptables-mod-extra libcap libcap-bin ruby ruby-yaml kmod-tun kmod-inet-diag unzip luci-compat luci luci-base"

# config img
zero="immortalwrt-${releases}-${amlogic}-${kernel}.img"

# file system type
bootfs="fat32"
rootfs="btrfs"

download_imagebuilder () {
    wget ${imagebuilder_repo}
    tar -xJf immortalwrt-imagebuilder-* && rm -f immortalwrt-imagebuilder-*.tar.xz
    mv -f immortalwrt-imagebuilder-* ${openwrt_dir}
}

custom_packages () {
    wget -P ${imagebuilder_path}/packages/ ${luci_app_openclash}
    wget -P ${imagebuilder_path}/packages/ ${luci_app_netmon}
    wget -P ${imagebuilder_path}/packages/ ${luci_app_shutdown}
    wget -P ${imagebuilder_path}/packages/ ${luci_app_tinyfm}
}

build_rootfs () {
    cd ${imagebuilder_path}
    make image PROFILE="Default" PACKAGES="${my_packages}" FILES="files"
    cd ${make_path}
}

build_img () {
    dd if=/dev/zero of=${zero} bs=1M count=1500 status=progress
    parted -s ${zero} mklabel msdos
    parted -s ${zero} mkpart primary ${bootfs} 1 255
    parted -s ${zero} mkpart primary ${rootfs} 255 1573
}

format_img () {
    loop_new="$(losetup -P -f --show "${zero}")"
    mkfs.vfat ${loop_new}p1
    mkfs.btrfs -f ${loop_new}p2
    fatlabel ${loop_new}p1 BOOT
    btrfs filesystem label ${loop_new}p2 ROOTFS
    losetup -D && sleep 10 && losetup -P -f ${zero}
}

adjustment_img () {
    mkdir -p BOOTFS && mkdir -p ROOTFS
    mount ${loop_new}p1 BOOTFS/
    mount ${loop_new}p2 ROOTFS/
    tar -xzvf ${make_path}/*.tar.gz -C ${bootfs_path}/
    rm -f ${make_path}/*.tar.gz
    wget -P ${bootfs_path}/dtb/amlogic/ ${dtb_repo}
    wget -P ${bootfs_path}/ ${boot_repo}
    tar -xzvf ${bootfs_path}/dtb/amlogic/*.tar.gz -C ${bootfs_path}/dtb/amlogic/
    rm -f ${bootfs_path}/dtb/amlogic/*.tar.gz
    tar -xzvf ${bootfs_path}/*.tar.gz -C ${bootfs_path}/
    rm -f ${bootfs_path}/*.tar.gz
    ls -a ${make_path}
    ls -a ${bootfs_path}/
    ls -a ${bootfs_path}/dtb/amlogic/
}

download_imagebuilder
custom_packages
build_rootfs
build_img
format_img
adjustment_img

exit 0
