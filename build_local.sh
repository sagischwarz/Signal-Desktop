#!/usr/bin/env bash
git lfs install

# Allow higher Node versions
sed 's#"node": "#&>=#' -i package.json

# Select node-gyp versions with python3 support
sed 's#"node-gyp": "5.0.3"#"node-gyp": "7.1.2"#' -i package.json
sed 's#"resolutions": {#"resolutions": {"node-sass/node-gyp": "^7.1.2",#' -i package.json

yarn install --ignore-engines

# Have SQLCipher dynamically link from OpenSSL
# See https://github.com/signalapp/Signal-Desktop/issues/2634
patch --forward --strip=1 --input="openssl-linking.patch"

# We can't read the release date from git so we use SOURCE_DATE_EPOCH instead
#patch --forward --strip=1 --input="expire-from-source-date-epoch.patch"

yarn generate exec:build-protobuf exec:transpile concat copy:deps sass
yarn build-release
