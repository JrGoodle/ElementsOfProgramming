#!/usr/bin/env bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" || exit 1

rm -rf ElementsOfProgramming.playground/Sources/*
cp -R EOP/*.swift ElementsOfProgramming.playground/Sources/
cp -R EOP/Types/*.swift ElementsOfProgramming.playground/Sources/
