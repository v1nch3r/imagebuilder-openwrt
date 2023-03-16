make_path="$(pwd)"
openwrt_dir="openwrt"
imagebuilder_path="${make_path}/${openwrt_dir}"
releases="21.02.1"
targets="armvirt"
processor="s905x"
imagebuilder_repo="https://downloads.immortalwrt.org/releases/${releases}/targets/${targets}/64/immortalwrt-imagebuilder-21.02.1-armvirt-64.Linux-x86_64.tar.xz"
my_packages="-luci-app-cpufreq -luci-app-turboacc -luci-app-filetransfer luci-theme-material luci-theme-argon luci-app-argon-config luci-app-ttyd luci-app-openclash luci-app-passwall luci-app-shutdown luci-app-netmonitor luci-app-zerotier nano htop openssh-sftp-server kmod-usb-net-cdc-ether usb-modeswitch comgt-ncm kmod-usb-net-huawei-cdc-ncm coreutils-nohup bash iptables dnsmasq-full curl ca-certificates ipset ip-full iptables-mod-tproxy iptables-mod-extra libcap libcap-bin ruby ruby-yaml kmod-tun kmod-inet-diag unzip luci-compat luci luci-base"
zero="immortalwrt-${releases}-${processor}.img"
attach="$(losetup -P -f)
detach="$(losetup -D)

wget ${imagebuilder_repo}
tar xf immortalwrt-imagebuilder-* && rm -r immortalwrt-imagebuilder-*.tar.xz
mv -f immortalwrt-imagebuilder-* ${openwrt_dir}
cp -r ${make_path}/packages/* ${imagebuilder_path}/packages
make image PROFILE="Default" PACKAGES="${my_packages}" FILES="files"

dd if=/dev/zero of=${zero} bs=1M count=1500 status=progress
parted -s ${zero} mklabel msdos
parted -s ${zero} mkpart primary fat32 1 255
parted -s ${zero} mkpart primary btrfs 255 1573
${attach} ${zero}
mkfs.vfat /dev/loop3p1
mkfs.btrfs -f /dev/loop3p2
fatlabel /dev/loop3p1 BOOT
btrfs filesystem label /dev/loop3p2 ROOTFS
${detach} && ${attach} ${zero}
mkdir -p BOOTFS && mkdir -p ROOTFS
mount /dev/loop4p1 BOOTFS/
mount /dev/loop4p2 ROOTFS/
lsblk
