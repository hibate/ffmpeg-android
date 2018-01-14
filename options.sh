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

#--------------------
# Standard options:
COMMON_OPTIONS=

# Licensing options:
COMMON_OPTIONS="$COMMON_OPTIONS --disable-gpl"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-nonfree"

# Configuration options:
COMMON_OPTIONS="$COMMON_OPTIONS --enable-runtime-cpudetect"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-gray"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-swscale-alpha"

# Program options:
COMMON_OPTIONS="$COMMON_OPTIONS --disable-programs"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffmpeg"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffplay"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffprobe"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-ffserver"

# Documentation options:
COMMON_OPTIONS="$COMMON_OPTIONS --disable-doc"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-htmlpages"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-manpages"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-podpages"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-txtpages"

# Component options:
COMMON_OPTIONS="$COMMON_OPTIONS --disable-avdevice"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-avcodec"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-avformat"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-avutil"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-swresample"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-swscale"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-postproc"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-avfilter"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-avresample"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-network"

# Hardware accelerators:
COMMON_OPTIONS="$COMMON_OPTIONS --disable-d3d11va"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-dxva2"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-vaapi"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-vda"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-vdpau"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-videotoolbox"

# Individual component options:
COMMON_OPTIONS="$COMMON_OPTIONS --disable-encoders"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-encoder=png"

# ./configure --list-decoders
COMMON_OPTIONS="$COMMON_OPTIONS --disable-decoders"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=aac"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=aac_latm"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=flv"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=h264"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=mp3*"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=vp6f"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=flac"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-decoder=hevc"

COMMON_OPTIONS="$COMMON_OPTIONS --disable-hwaccels"

# ./configure --list-muxers
COMMON_OPTIONS="$COMMON_OPTIONS --disable-muxers"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-muxer=mp4"

# ./configure --list-demuxers
COMMON_OPTIONS="$COMMON_OPTIONS --disable-demuxers"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=aac"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=concat"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=data"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=flv"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=hls"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=live_flv"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=mov"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=mp3"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=mpegps"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=mpegts"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=mpegvideo"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=flac"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=hevc"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-demuxer=h264"

# ./configure --list-parsers
COMMON_OPTIONS="$COMMON_OPTIONS --disable-parsers"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-parser=aac"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-parser=aac_latm"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-parser=h264"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-parser=flac"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-parser=hevc"

# ./configure --list-bsf
COMMON_OPTIONS="$COMMON_OPTIONS --enable-bsfs"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=chomp"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=dca_core"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=dump_extradata"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=hevc_mp4toannexb"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=imx_dump_header"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=mjpeg2jpeg"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=mjpega_dump_header"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=mov2textsub"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=mp3_header_decompress"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=mpeg4_unpack_bframes"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=noise"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=remove_extradata"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=text2movsub"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-bsf=vp9_superframe"

# ./configure --list-protocols
COMMON_OPTIONS="$COMMON_OPTIONS --enable-protocols"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-protocol=async"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=bluray"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=concat"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=crypto"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=ffrtmpcrypt"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-protocol=ffrtmphttp"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=gopher"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=icecast"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=librtmp*"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=libssh"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=md5"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=mmsh"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=mmst"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=rtmp*"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-protocol=rtmp"
COMMON_OPTIONS="$COMMON_OPTIONS --enable-protocol=rtmpt"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=rtp"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=sctp"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=srtp"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=subfile"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-protocol=unix"

#
COMMON_OPTIONS="$COMMON_OPTIONS --disable-devices"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-filters"

# External library support:
COMMON_OPTIONS="$COMMON_OPTIONS --disable-iconv"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-audiotoolbox"
COMMON_OPTIONS="$COMMON_OPTIONS --disable-videotoolbox"

