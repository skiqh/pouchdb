#!/bin/bash

TESTS_DIR=./tests/chrome/

rm -fr $TESTS_DIR/www
mkdir -p $TESTS_DIR/www

cp -r vendor $TESTS_DIR/www/vendor
mkdir -p $TESTS_DIR/www/node_modules
cp -r node_modules/mocha node_modules/chai node_modules/es5-shim \
    $TESTS_DIR/www/node_modules
mkdir -p $TESTS_DIR/www/tests
cp -r tests/*html tests/*js tests/deps tests/unit $TESTS_DIR/www/tests

mkdir -p $TESTS_DIR/www/dist
cp dist/pouchdb*js $TESTS_DIR/www/dist

if [[ ! -z $GREP ]]; then
  ./node_modules/replace/bin/replace.js '<body>' \
    "<body><script>window.GREP = ""'"$GREP"'"";</script>" \
    $TESTS_DIR/www/tests/test.html
fi

if [[ ! -z $ES5_SHIMS ]]; then
  ES5_SHIM=$ES5_SHIMS # synonym
fi

if [[ ! -z $ES5_SHIM ]]; then
  ./node_modules/replace/bin/replace.js '<body>' \
    "<body><script>window.ES5_SHIM = ""'"$ES5_SHIM"'"";</script>" \
    $TESTS_DIR/www/tests/test.html
fi

if [[ ! -z $COUCH_HOST ]]; then
  ./node_modules/replace/bin/replace.js '<body>' \
    "<body><script>window.COUCH_HOST = ""'"$COUCH_HOST"'"";</script>" \
    $TESTS_DIR/www/tests/test.html
fi

# TODO: figure out how to launch chromium
CHROMIUM=/Applications/Chromium.app/Contents/MacOS/Chromium

$CHROMIUM --load-and-launch-app=tests/chrome