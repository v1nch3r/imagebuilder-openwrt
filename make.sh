name: Immortalwrt

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-20.04
    if: ${{ github.event.repository.owner.id }} == ${{ github.event.sender.id }}


    steps:
      - name: Initialization environment
        env:
          DEBIAN_FRONTEND: noninteractive
        run: |
          sudo rm -rf /etc/apt/sources.list.d/* /usr/share/dotnet /usr/local/lib/android /opt/ghc
          sudo -E apt-get -qq update
          sudo -E apt-get -qq install $(curl -fsSL git.io/depends-ubuntu-2004)
          sudo -E apt-get -qq autoremove --purge
          sudo -E apt-get -qq clean
          sudo ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
          docker image prune -a -f
          mkdir -p workspace
          
      - name: Checkout
        uses: actions/checkout@main

      - name: Run make.sh
        run: sh make.sh
      
      - name: Upload OpenWrt Firmware to Release
        uses: ncipollo/release-action@main
        if: ${{ env.PACKAGED_STATUS }} == 'success' && !cancelled()
        with:
          tag: immortalwrt
          artifacts: "*.img.gz"
          allowUpdates: true
          token: ${{ secrets.GITHUB_TOKEN }}
