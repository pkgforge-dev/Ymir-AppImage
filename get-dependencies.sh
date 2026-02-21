#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    autoconf-archive \
    clang            \
    cmake            \
    libdecor         \
    python           \
    vcpkg

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package 

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of Ymir..."
echo "---------------------------------------------------------------"
REPO="https://github.com/StrikerX3/Ymir"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./Ymir
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Ymir
mkdir -p build && cd build
cmake_opts=(
    -D Ymir_ENABLE_TESTS=OFF
    -D Ymir_ENABLE_DEVLOG=OFF
    -D Ymir_ENABLE_IMGUI_DEMO=OFF
    -D Ymir_ENABLE_SANDBOX=OFF
    -DCMAKE_TOOLCHAIN_FILE=vcpkg/scripts/buildsystems/vcpkg.cmake
    -DCMAKE_BUILD_TYPE=Release
    -DVCPKG_BUILD_TYPE=release
    --fresh
)
# Enable AVX2 only for x86_64
if [ "$ARCH" == "x86_64" ]; then
    cmake_opts+=(-D Ymir_AVX2=ON)
else
    cmake_opts+=(-D Ymir_AVX2=OFF -DCMAKE_CXX_FLAGS="-flax-vector-conversions")
fi

cmake .. "${cmake_opts[@]}"
make -j$(nproc)
mv -v apps/ymir-sdl3/ymir-sdl3-0.3.0 ../../AppDir/bin/ymir-sdl3
mv -v ../apps/ymir-sdl3/res/ymir.png ../../AppDir
