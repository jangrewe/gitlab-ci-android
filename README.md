# gitlab-ci-android
This Docker image contains the Android SDK and most common packages necessary for building Android apps in a CI tool like GitLab CI. Make sure your CI environment's caching works as expected, this greatly improves the build time, especially if you use multiple build jobs.

A `.gitlab-ci.yml` with caching of your project's dependencies would look like this:

```
image: jangrewe/gitlab-ci-android

variables:
  ANDROID_COMPILE_SDK: "27"

stages:
- test
- build

before_script:
- export GRADLE_USER_HOME=$(pwd)/.gradle
- chmod +x ./gradlew
- apt-get update -y && apt-get install wget -y

cache:
  key: ${CI_PROJECT_ID}
  paths:
  - .gradle/

build:
  stage: build
  script:
  - ./gradlew assemble
  artifacts:
    paths:
    - app/build/outputs/apk/release/app-release-unsigned.apk
    - app/build/outputs/apk/debug/app-debug.apk

unitTests:
  stage: test
  script:
  - ./gradlew test

functionalTests:
  stage: test
  script:
  - wget --quiet --output-document=android-wait-for-emulator https://raw.githubusercontent.com/travis-ci/travis-cookbooks/0f497eb71291b52a703143c5cd63a217c8766dc9/community-cookbooks/android-sdk/files/default/android-wait-for-emulator
  - chmod +x android-wait-for-emulator
  - echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "system-images;android-${ANDROID_COMPILE_SDK};google_apis_playstore;x86"
  - echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --update
  - echo no | ${ANDROID_HOME}/tools/bin/avdmanager create avd -k "system-images;android-${ANDROID_COMPILE_SDK};google_apis_playstore;x86" -n test
  - ${ANDROID_HOME}/tools/emulator -avd test -no-window -no-audio &
  - ./android-wait-for-emulator
  - adb shell input keyevent 82
  - ./gradlew cAT
```
