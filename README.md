# FFmpeg 编译脚本

* Android 全平台编译
* 编译成单个库文件

## 编译环境

* Ubuntu 14.04.5 x64
* Android NDK r15
* FFmpeg-3.4.1

## 编译

```sh
$ export ANDROID_NDK="<path to your ndk directory>"
$ ./build_android.sh <path to ffmpeg source directory>
```

默认编译后的库路径为当前 shell 路径下的 ffmpeg-build 文件夹下。

### 选择 ABI

通过修改 `APP_ABI` 变量的值来改变编译平台，默认全平台编译。

### 修改 API 等级

通过修改 `ANDROID_PLATFORM` 改变 API 等级。

默认编译级别如下:

ABI         | 默认级别     | 最小支持级别
------------|--------------|-----------------
arm64-v8a   | android-21   | android-21
armeabi     | android-9    | -
armeabi-v7a | android-9    | -
mips        | android-9    | -
mips64      | android-21   | android-21
x86         | android-9    | -
x86_64      | android-21   | android-21

### 修改编译选项

通过修改 options.sh 文件来改变编译选项。

## 并行编译

通过修改 `MAKE_FLAGS` 改变并行任务大小，默认为4个线程。

## 使用 ccache 加速

编译 ccache 并安装，设置 ccache 缓存大小:

```sh
$ ccache -M 2G
```

编译脚本会自动使用 ccache 加速编译。

## 使用其他版本的 NDK 编译

若当前 NDK 版本与笔者不一致，请参考当前 NDK 版本修改不同 ABI 对应的 `CROSS_PREFIX` 和 `SYSROOT` 路径。

## 在 Mac OS X 下编译

修改 `HOST_PLATFORM` 为 `darwin-x86_64` 即可。