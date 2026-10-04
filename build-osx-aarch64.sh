#!/bin/bash

set -e

APPBASE="build/macos-aarch64/Augment.app"

build() {
    echo Launcher sha256sum
    shasum -a 256 build/libs/Augment.jar

    pushd native
    cmake -DCMAKE_OSX_ARCHITECTURES=arm64 -B build-aarch64 .
    cmake --build build-aarch64 --config Release
    popd

    source .jdk-versions.sh

    rm -rf build/macos-aarch64
    mkdir -p build/macos-aarch64

    if ! [ -f mac_aarch64_jre.tar.gz ] ; then
        curl -Lo mac_aarch64_jre.tar.gz $MAC_AARCH64_LINK
    fi

    echo "$MAC_AARCH64_CHKSUM  mac_aarch64_jre.tar.gz" | shasum -c

    mkdir -p $APPBASE/Contents/{MacOS,Resources}

    cp native/build-aarch64/src/Augment $APPBASE/Contents/MacOS/
    cp build/libs/Augment.jar $APPBASE/Contents/Resources/
    cp packr/macos-aarch64-config.json $APPBASE/Contents/Resources/config.json
    cp build/filtered-resources/Info.plist $APPBASE/Contents/
    cp osx/runelite.icns $APPBASE/Contents/Resources/icons.icns

    tar zxf mac_aarch64_jre.tar.gz
    mkdir $APPBASE/Contents/Resources/jre
    mv $MAC_AARCH64_RELEASE-jre/Contents/Home/* $APPBASE/Contents/Resources/jre

    echo Setting world execute permissions on Augment
    pushd $APPBASE
    chmod g+x,o+x Contents/MacOS/Augment
    popd

    otool -l $APPBASE/Contents/MacOS/Augment
}

dmg() {
    bash tools/package-macos-release.sh "$APPBASE" Augment-aarch64.dmg ULFO
}

while test $# -gt 0; do
  case "$1" in
    --build)
      build
      shift
      ;;
    --dmg)
      dmg
      shift
      ;;
    *)
      break
      ;;
  esac
done