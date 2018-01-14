#!/bin/bash
#
# Copyright (C) 2017 Hibate <ycaia86@126.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This script is based on projects below
# https://github.com/yixia/FFmpeg-Android
# https://github.com/Bilibili/ijkplayer


#########################################################################
#
# 编译选项
#
#########################################################################

PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
PRGDIR=`dirname "$PRG"`

# 当前 shell 执行路径
CURRENT_DIR=$(pwd)

# ffmpeg 源码目录
FFMPEG_SOURCE=$1
# 编译平台环境("darwin-x86_64" for Mac OS X)
HOST_PLATFORM="linux-x86_64"

# make 参数
MAKE_FLAGS="-j4"

# 编译路径
INSTALL_DST="${CURRENT_DIR}/ffmpeg-build"

# NDK 环境
NDK_PATH=${NDK_PATH}

# 编译选项文件
OPTIONS_SOURCE="${PRGDIR}/options.sh"

# 选择编译的 abi 类型
APP_ABI=(
    "arm64-v8a"
    "armeabi"
    "armeabi-v7a"
    "mips"
    "mips64"
    "x86"
    "x86_64"
)

#########################################################################
#
# 选择 NDK_PATH
#
#########################################################################

if [ -z "${NDK_PATH}" ] && [ ! -z "${ANDROID_NDK}" ]; then
    NDK_PATH=${ANDROID_NDK}
fi
if [ -z "${NDK_PATH}" ] && [ ! -z "${ANDROID_NDK_HOME}" ]; then
    NDK_PATH=${ANDROID_NDK_HOME}
fi

#########################################################################
#
# Checkout
#
#########################################################################

# 检查编译环境
if [ -z "${NDK_PATH}" ]; then
    echo "Please set NDK_PATH or ANDROID_NDK_HOME environment."
    exit 1
fi
if [ ! -f "${NDK_PATH}/ndk-build" ]; then
    echo "Is this ndk folder: ${NDK_PATH}"
    exit 1
fi
if [ -z "${FFMPEG_SOURCE}" ]; then
    echo "Please select ffmpeg source folder!"
    exit 1
fi
if [ ! -d "${FFMPEG_SOURCE}" ]; then
    echo "The ffmpeg source folder not exists!"
    exit 1
fi
if [ ! -f "${OPTIONS_SOURCE}" ]; then
    echo "The ffmpeg configure file[${OPTIONS_SOURCE}] not exists!"
    exit 1
fi

#########################################################################
#
# Setup options
#
#########################################################################

# 获取 ffmpeg 源码绝对路径
cd ${FFMPEG_SOURCE}
FFMPEG_SOURCE=$(pwd)
cd -

. ${OPTIONS_SOURCE}

COMMON_OPTIONS="
    --target-os=android \
    --enable-static \
    --disable-shared \
    ${COMMON_OPTIONS} \
    " \

COMMON_CFLAGS="\
    -O3 -Wall -pipe \
    -std=c99 \
    -ffast-math \
    -fstrict-aliasing -Werror=strict-aliasing \
    -Wno-psabi -Wa,--noexecstack \
    -DANDROID -DNDEBUG \
    " \

#########################################################################
#
# Functions
#
#########################################################################

file_mkdirs() {
    path_tmp=$1
    if [ ! -z "${path_tmp}" ] && [ ! -d "${path_tmp}" ]; then
        mkdir -p ${path_tmp}
    fi
    unset path_tmp
}

check_command_exists() {
    cmd_tmp=$1
    type ${cmd_tmp} >/dev/null 2>&1 || {
        unset cmd_tmp
        echo false
        return
    }
    unset cmd_tmp
    echo true
}

#########################################################################
#
# Build
#
#########################################################################


for abi in ${APP_ABI[@]}
do
    PREFIX="${INSTALL_DST}/${abi}"

    ARCH=
    CPU=
    ANDROID_PLATFORM=
    CROSS_PREFIX=
    SYSROOT=
    EXTRA_OPTIONS="${COMMON_OPTIONS}"
    EXTRA_CFLAGS="${COMMON_CFLAGS}"
    EXTRA_LDFLAGS=""
    EXTRA_LDEXEFLAGS=""
    FFMPEG_ASSEMBLER_MODULES=""

    case ${abi} in
        arm64-v8a)
            ARCH=aarch64
            CPU=armv8-a
            ANDROID_PLATFORM=android-21
            CROSS_PREFIX="${NDK_PATH}/toolchains/aarch64-linux-android-4.9/prebuilt/${HOST_PLATFORM}/bin/aarch64-linux-android-"
            SYSROOT="${NDK_PATH}/platforms/${ANDROID_PLATFORM}/arch-arm64/"
            EXTRA_OPTIONS="\
                ${EXTRA_OPTIONS} \
                --enable-yasm \
                " \
            EXTRA_LDEXEFLAGS="\
                -pie \
                " \
            FFMPEG_ASSEMBLER_MODULES="${ARCH} neon"
            ;;
        armeabi)
            ARCH=arm
            CPU=armv5te
            ANDROID_PLATFORM=android-9
            CROSS_PREFIX="${NDK_PATH}/toolchains/arm-linux-androideabi-4.9/prebuilt/${HOST_PLATFORM}/bin/arm-linux-androideabi-"
            SYSROOT="${NDK_PATH}/platforms/${ANDROID_PLATFORM}/arch-arm/"
            EXTRA_OPTIONS="\
                ${EXTRA_OPTIONS} \
                --enable-asm \
                " \
            EXTRA_CFLAGS="\
                ${EXTRA_CFLAGS} \
                -march=armv5te \
                -mtune=arm9tdmi \
                -msoft-float \
                " \
            EXTRA_LDEXEFLAGS="\
                -pie \
                " \
            FFMPEG_ASSEMBLER_MODULES="${ARCH}"
            ;;
        armeabi-v7a)
            ARCH=arm
            CPU=armv7-a
            ANDROID_PLATFORM=android-9
            CROSS_PREFIX="${NDK_PATH}/toolchains/arm-linux-androideabi-4.9/prebuilt/${HOST_PLATFORM}/bin/arm-linux-androideabi-"
            SYSROOT="${NDK_PATH}/platforms/${ANDROID_PLATFORM}/arch-arm/"
            EXTRA_OPTIONS="\
                ${EXTRA_OPTIONS} \
                --enable-asm \
                " \
            EXTRA_CFLAGS="\
                ${EXTRA_CFLAGS} \
                -march=armv7-a \
                -mfloat-abi=softfp \
                " \
            EXTRA_LDFLAGS="\
                -Wl,--fix-cortex-a8 \
                " \
            EXTRA_LDEXEFLAGS="\
                -pie \
                " \
            FFMPEG_ASSEMBLER_MODULES="${ARCH}"
            ;;
        mips)
            ARCH=mips
            CPU=mips32
            ANDROID_PLATFORM=android-9
            CROSS_PREFIX="${NDK_PATH}/toolchains/mipsel-linux-android-4.9/prebuilt/${HOST_PLATFORM}/bin/mipsel-linux-android-"
            SYSROOT="${NDK_PATH}/platforms/${ANDROID_PLATFORM}/arch-mips/"
            EXTRA_OPTIONS="\
                ${EXTRA_OPTIONS} \
                --enable-yasm \
                --disable-asm \
                " \
            EXTRA_CFLAGS="\
                ${EXTRA_CFLAGS} \
                -mips32 \
                " \
            EXTRA_LDFLAGS="\
                -mips32 \
                -no-canonical-prefixes \
                " \
            EXTRA_LDEXEFLAGS="\
                -pie \
                " \
            FFMPEG_ASSEMBLER_MODULES="${ARCH}"
            ;;
        mips64)
            ARCH=mips64
            CPU=mips64r6
            ANDROID_PLATFORM=android-21
            CROSS_PREFIX="${NDK_PATH}/toolchains/mips64el-linux-android-4.9/prebuilt/${HOST_PLATFORM}/bin/mips64el-linux-android-"
            SYSROOT="${NDK_PATH}/platforms/${ANDROID_PLATFORM}/arch-mips64/"
            EXTRA_OPTIONS="\
                ${EXTRA_OPTIONS} \
                --enable-yasm \
                --disable-asm \
                " \
            EXTRA_LDFLAGS="\
                -no-canonical-prefixes \
                " \
            EXTRA_LDEXEFLAGS="\
                -pie \
                " \
            FFMPEG_ASSEMBLER_MODULES="${ARCH}"
            ;;
        x86)
            ARCH=x86
            CPU=i686
            ANDROID_PLATFORM=android-9
            CROSS_PREFIX="${NDK_PATH}/toolchains/x86-4.9/prebuilt/${HOST_PLATFORM}/bin/i686-linux-android-"
            SYSROOT="${NDK_PATH}/platforms/${ANDROID_PLATFORM}/arch-x86/"
            EXTRA_OPTIONS="\
                ${EXTRA_OPTIONS} \
                --enable-yasm \
                --disable-asm \
                " \
            EXTRA_LDEXEFLAGS="\
                -pie \
                " \
            FFMPEG_ASSEMBLER_MODULES="${ARCH}"
            ;;
        x86_64)
            ARCH=x86_64
            CPU=x86_64
            ANDROID_PLATFORM=android-21
            CROSS_PREFIX="${NDK_PATH}/toolchains/x86_64-4.9/prebuilt/${HOST_PLATFORM}/bin/x86_64-linux-android-"
            SYSROOT="${NDK_PATH}/platforms/${ANDROID_PLATFORM}/arch-x86_64/"
            EXTRA_OPTIONS="\
                ${EXTRA_OPTIONS} \
                --enable-yasm \
                --disable-asm \
                " \
            EXTRA_LDEXEFLAGS="\
                -pie \
                " \
            FFMPEG_ASSEMBLER_MODULES="${ARCH}"
            ;;
        *)
            ;;
    esac

    if [ ! -z "${ARCH}" ] && [ ! -z "CPU" ] && [ ! -z "${CROSS_PREFIX}" ] && [ ! -z "${SYSROOT}" ]; then
        CROSS_CC="${CROSS_PREFIX}gcc"
        if [ $(check_command_exists "ccache") = true ]; then
            CROSS_CC="ccache ${CROSS_CC}"
        fi
        CROSS_STRIP="${CROSS_PREFIX}strip"

        echo "----------------------------"
        echo "build ffmpeg for: ${abi}"
        echo "----------------------------"

        file_mkdirs ${PREFIX}

        cd ${FFMPEG_SOURCE}
        ./configure \
            --prefix="${PREFIX}" \
            --arch=${ARCH} \
            --cpu=${CPU} \
            --cross-prefix="${CROSS_PREFIX}" \
            --cc="${CROSS_CC}" \
            --sysroot="${SYSROOT}" \
            --extra-cflags="${EXTRA_CFLAGS}" \
            --extra-ldflags="${EXTRA_LDFLAGS}" \
            --extra-ldexeflags="${EXTRA_LDEXEFLAGS}" \
            ${EXTRA_OPTIONS} \
            &&

        [ $PIPESTATUS == 0 ] || exit 1

        cp config.* ${PREFIX}

        make clean
        make ${MAKE_FLAGS} || exit 1
        make install || exit 1

        echo "----------------------------"
        echo "link ffmpeg"
        echo "----------------------------"

        FFMPEG_MODULES="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"

        FFMPEG_C_OBJ_FILES=
        FFMPEG_ASM_OBJ_FILES=

        for module in ${FFMPEG_MODULES}
        do
            C_OBJ_FILES="${module}/*.o"
            if ls ${C_OBJ_FILES} 1> /dev/null 2>&1; then
                echo "link ${C_OBJ_FILES}"
                FFMPEG_C_OBJ_FILES="${FFMPEG_C_OBJ_FILES} ${C_OBJ_FILES}"
            fi

            for assembler_module in ${FFMPEG_ASSEMBLER_MODULES}
            do
                ASM_OBJ_FILES="${module}/${assembler_module}/*.o"
                if ls $ASM_OBJ_FILES 1> /dev/null 2>&1; then
                    echo "link ${ASM_OBJ_FILES}"
                    FFMPEG_ASM_OBJ_FILES="${FFMPEG_ASM_OBJ_FILES} ${ASM_OBJ_FILES}"
                fi
            done
        done

        ${CROSS_CC} \
            -lm \
            -lz \
            -shared \
            --sysroot=${SYSROOT} \
            -Wl,--no-undefined \
            -Wl,-z,noexecstack \
            ${EXTRA_LDFLAGS} \
            -Wl,-soname,libffmpeg.so \
            ${FFMPEG_C_OBJ_FILES} \
            ${FFMPEG_ASM_OBJ_FILES} \
            -o ${PREFIX}/libffmpeg.so

        [ $PIPESTATUS == 0 ] || exit 1

        if [ -f "${PREFIX}/libffmpeg.so" ]; then
            cp ${PREFIX}/libffmpeg.so ${PREFIX}/libffmpeg-debug.so
            ${CROSS_STRIP} --strip-unneeded ${PREFIX}/libffmpeg.so
        fi

        cd -
    fi
done

exit 0
