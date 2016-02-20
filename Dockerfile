#
# GitLab CI: Android v0.1
#
# https://hub.docker.com/r/jangrewe/gitlab-ci-android/
# https://git.faked.org/jan/gitlab-ci-android
#

FROM alpine:latest
MAINTAINER Jan Grewe <jan@faked.org>

ENV SDK_VERSION="24.4.1"
ENV SDK_PACKAGES="android-23,build-tools-23.0.2,addon-google_apis-google-23,extra-android-support,extra-google-google_play_services"
ENV GRADLE_VERSION="2.11"

RUN apk update && \
    apk upgrade && \
    apk add \
      bash \
      openjdk8 \
    && \
    rm -rf /var/cache/apk/*

ADD http://dl.google.com/android/android-sdk_r${SDK_VERSION}-linux.tgz /sdk.tgz
RUN tar zxvf sdk.tgz && \
    rm -v /sdk.tgz && \
    mv /android-sdk-linux /sdk && \
    echo 'export PATH=$PATH:/sdk/tools/templates/gradle/wrapper:/sdk/tools/' >> .bashrc

RUN echo "y" | /sdk/tools/android update sdk -u --filter ${SDK_PACKAGES}
