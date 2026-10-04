#!/bin/bash

set -e

APPBASE="build/macos-x64/Augment.app"

build() {
    echo Launcher sha256sum
    shasum -a 256 build/libs/Augment.jar

    pushd native
    cmake -DCMAKE_OSX_ARCHITECTURES=x86_64 -B build-x64 .
    cmake --build build-x64 --config Release
    popd

    source .jdk-versions.sh

    rm -rf build/macos-x64
    mkdir -p build/macos-x64

    if ! [ -f mac64_jre.tar.gz ] ; then
        curl -Lo mac64_jre.tar.gz $MAC_AMD64_LINK
    fi

    echo "$MAC_AMD64_CHKSUM  mac64_jre.tar.gz" | shasum -c

    mkdir -p $APPBASE/Contents/{MacOS,Resources}

    cp native/build-x64/src/Augment $APPBASE/Contents/MacOS/
    cp build/libs/Augment.jar $APPBASE/Contents/Resources/
    cp packr/macos-x64-config.json $APPBASE/Contents/Resources/config.json
    cp build/filtered-resources/Info.plist $APPBASE/Contents/
    cp osx/runelite.icns $APPBASE/Contents/Resources/icons.icns

    tar zxf mac64_jre.tar.gz
    mkdir $APPBASE/Contents/Resources/jre
    mv $MAC_AMD64_RELEASE-jre/Contents/Home/* $APPBASE/Contents/Resources/jre

    echo Setting world execute permissions on Augment
    pushd $APPBASE
    chmod g+x,o+x Contents/MacOS/Augment
    popd

    otool -l $APPBASE/Contents/MacOS/Augment
}

dmg() {
    bash tools/package-macos-release.sh "$APPBASE" Augment-x64.dmg UDBZ
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