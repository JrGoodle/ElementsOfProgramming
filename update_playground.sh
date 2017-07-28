#!/usr/bin/env bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" || exit 1

rm -rf ElementsOfProgramming.playground/Sources/*
cp ElementsOfProgramming/*.swift ElementsOfProgramming.playground/Sources/
cp ElementsOfProgramming/Types/*.swift ElementsOfProgramming.playground/Sources/
