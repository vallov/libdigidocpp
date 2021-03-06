#!/bin/bash

case "$@" in
*simulator*)
  echo "Building for iOS Simulator"
  TARGET=iphonesimulator
  ARCHS="i386;x86_64"
  ;;
*)
  echo "Building for iOS"
  TARGET=iphoneos
  ARCHS="armv7;armv7s;arm64"
  ;;
esac

TARGET_PATH=/Library/EstonianIDCard.${TARGET}
rm -rf ${TARGET}
mkdir -p ${TARGET}
cd ${TARGET}
cmake \
    -DCMAKE_C_COMPILER_WORKS=yes \
    -DCMAKE_CXX_COMPILER_WORKS=yes \
    -DCMAKE_C_FLAGS="-miphoneos-version-min=7.0 -std=gnu89 -Wno-implicit-function-declaration" \
    -DCMAKE_CXX_FLAGS="-miphoneos-version-min=7.0" \
    -DCMAKE_BUILD_TYPE="RelWithDebInfo" \
    -DCMAKE_OSX_SYSROOT=$(xcrun -sdk ${TARGET} --show-sdk-path) \
    -DCMAKE_OSX_ARCHITECTURES="${ARCHS}" \
    -DCMAKE_INSTALL_PREFIX=${TARGET_PATH} \
    -DOPENSSL_ROOT_DIR=${TARGET_PATH} \
    -DOPENSSL_CRYPTO_LIBRARY=${TARGET_PATH}/lib/libcrypto.a \
    -DOPENSSL_SSL_LIBRARY=${TARGET_PATH}/lib/libssl.a \
    -DXERCESC_INCLUDE_DIR=${TARGET_PATH}/include \
    -DXERCESC_LIBRARY=${TARGET_PATH}/lib/libxerces-c.a \
    -DXMLSECURITYC_INCLUDE_DIR=${TARGET_PATH}/include \
    -DXMLSECURITYC_LIBRARY=${TARGET_PATH}/lib/libxml-security-c.a \
    -DXSD_INCLUDE_DIR=${TARGET_PATH}/include \
    -DXSD_EXECUTABLE=${TARGET_PATH}/bin/xsd \
    -DLIBDIGIDOC_INCLUDE_DIR=${TARGET_PATH}/include \
    -DLIBDIGIDOC_LIBRARY=${TARGET_PATH}/lib/libdigidoc.a \
    -DFRAMEWORK=off \
    -DUSE_KEYCHAIN=off \
    -DBUILD_TOOLS=off \
    -DBUILD_TYPE=STATIC \
    ../../..
make
sudo make install
cd ..
