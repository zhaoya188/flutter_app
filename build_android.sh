#!/usr/bin/env bash

flutter clean
flutter packages get -v

cd ./addfutter2app/
./gradlew clean --stacktrace
./gradlew assembleRelease --stacktrace -i
cd ../

ls -asl ./addfutter2app/app/build/outputs/apk/release/

