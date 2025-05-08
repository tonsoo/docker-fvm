FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install dependencies
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y \
    tzdata \
    git \
    unzip \
    curl \
    zip \
    xz-utils \
    libglu1-mesa \
    openjdk-11-jdk \
    adb \
    android-tools-adb \
    android-tools-fastboot \
    wget

# Install Java 17 (compatible with the Android SDK)
RUN apt-get install -y openjdk-17-jdk

# Set Java 17 as default
RUN update-alternatives --config java && \
    update-alternatives --config javac

# Android SDK installation
ENV SDKS=/sdk
ENV ANDROID_SDK_ROOT=$SDKS/android
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm cmdline-tools.zip

ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:${PATH}"

# Accept licenses and install required components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Install FVM
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    curl -fsSL https://fvm.app/install.sh | bash

# Config fvm
RUN fvm config --cache-path /sdk/fvm

# Choose what version of flutter to use
ARG FLUTTER_VERSION=stable
ENV FLUTTER_VERSION=$FLUTTER_VERSION

# Setup command alias for flutter, so "flutter" = "fvm flutter"
ENV ALIASES=$SDK/alias
ENV FLUTTER_ALIAS=$ALIASES/flutter
RUN mkdir -p $ALIASES
COPY flutter.sh $FLUTTER_ALIAS
RUN chmod +x $FLUTTER_ALIAS

ENV PATH="${PATH}:${ALIASES}"

RUN apt-get autoremove -y

WORKDIR /app

CMD [ "bash" ]