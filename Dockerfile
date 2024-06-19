FROM gitpod/openvscode-server:latest

USER root

# Update package list and install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-17-jdk wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Switch to the non-root user
USER openvscode-server

# Create the Android SDK directory
RUN mkdir -p $HOME/.android_sdk/cmdline-tools && \
    mkdir -p $HOME/.android_sdk/platform-tools

# Download and unzip command line tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d $HOME/.android_sdk/cmdline-tools && \
    mv $HOME/.android_sdk/cmdline-tools/cmdline-tools $HOME/.android_sdk/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Download and unzip platform tools
RUN wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip -O /tmp/platform-tools.zip && \
    unzip /tmp/platform-tools.zip -d $HOME/.android_sdk && \
    rm /tmp/platform-tools.zip

# Set environment variables
ENV ANDROID_SDK_ROOT="$HOME/.android_sdk"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"
ENV PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"

# Ensure the environment variables are available in the user's shell
RUN echo 'export ANDROID_SDK_ROOT="$HOME/.android_sdk"' >> $HOME/.bashrc && \
    echo 'export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"' >> $HOME/.bashrc && \
    echo 'export PATH="$ANDROID_SDK_ROOT/platform-tools:$PATH"' >> $HOME/.bashrc

