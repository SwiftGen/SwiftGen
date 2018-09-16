#!/bin/sh
cat $1 | sed s@"swiftlint:disable all"@" --"@ | swiftlint --use-stdin --strict | sed s@"<nopath>"@"$1"@
