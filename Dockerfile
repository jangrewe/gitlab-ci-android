#
# GitLab CI: Android v0.2
#
# https://hub.docker.com/r/jangrewe/gitlab-ci-android/
# https://git.faked.org/jan/gitlab-ci-android
#

FROM ubuntu:15.10
MAINTAINER Jan Grewe <jan@faked.org>

ENV SDK_VERSION "24.4.1"
ENV SDK_PACKAGES "plattform-tools,build-tools-23.0.3,android-23,addon-google_apis-google-23,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository"
ENV GRADLE_VERSION "2.12"
ENV PATH "$PATH:/sdk/tools/templates/gradle/wrapper:/sdk/tools/"
ENV DEBIAN_FRONTEND noninteractive
ENV ANDROID_HOME "/sdk"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      libc6-i386 \
      lib32stdc++6 \
      lib32gcc1 \
      lib32ncurses5 \
      lib32z1 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/ssl/certs/java/cacerts; \
    /var/lib/dpkg/info/ca-certificates-java.postinst configure

ADD http://dl.google.com/android/android-sdk_r${SDK_VERSION}-linux.tgz /sdk.tgz
RUN tar zxvf sdk.tgz && \
    rm -v /sdk.tgz && \
    mv /android-sdk-linux /sdk

RUN (while [ 1 ]; do sleep 5; echo y; done) | /sdk/tools/android update sdk -u -a -t ${SDK_PACKAGES}

RUN sed -i "s#distributionUrl=.*#distributionUrl=http\://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip#" /sdk/tools/templates/gradle/wrapper/gradle/wrapper/gradle-wrapper.properties && \
    /sdk/tools/templates/gradle/wrapper/gradlew
