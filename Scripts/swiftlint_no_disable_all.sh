#!/bin/sh
grep -v '// swiftlint:disable all' $1 | swiftlint --use-stdin --strict | sed s@"<nopath>"@"$1"@
