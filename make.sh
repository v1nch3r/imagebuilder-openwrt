#!/bin/sh

make_path="$(pwd)"
openwrt_dir="openwrt"
imagebuilder_path="${make_path}/${openwrt_dir}"
releases="21.02.1"
targets="armvirt"
imagebuilder_repo="https://downloads.immortalwrt.org/releases/${releases}/targets/${targets}/64/immortalwrt-imagebuilder-${releases}-${targets}-64.Linux-x86_64.tar.xz"

download_imagebuilder () {
    wget ${imagebuilder_repo}
    ls -a
}

exit 0
