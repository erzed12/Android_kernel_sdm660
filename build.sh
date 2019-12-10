#!/bin/bash

# Color
green='\033[0;32m'
echo -e "$green"

# Clone depedencies
git clone --depth=1 https://github.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-6032204.git -b 10.0 ~/clang
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b android-9.0.0_r45 ~/toolchain
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-9.0.0_r39 ~/toolchain_32

# Main Environment
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Hachiman"
export KBUILD_BUILD_HOST="BuildServer"
export CROSS_COMPILE=/root/toolchain/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/root/toolchain_32/bin/arm-linux-androideabi-
export KBUILD_COMPILER_STRING=$(/root/clang/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')


mkdir -p out

make O=out ARCH=arm64 aurora_defconfig

make -j$(nproc --all) O=out ARCH=arm64 \
                        CC="/root/clang/bin/clang" \
                        CLANG_TRIPLE="aarch64-linux-gnu-"