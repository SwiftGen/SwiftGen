#!/bin/bash

PROJECT_DIR="${PROJECT_DIR:-`cd "$(dirname $0)/..";pwd`}"
SWIFTLINT="${PROJECT_DIR}/Pods/SwiftLint/swiftlint"
CONFIG="${PROJECT_DIR}/.swiftlint.yml"

# possible paths
paths_swiftgen_sources="Sources/SwiftGen"
paths_swiftgen_tests="Tests/SwiftGenTests"
paths_swiftgenkit_sources="Sources/SwiftGenKit"
paths_swiftgenkit_tests="Tests/SwiftGenKitTests"
paths_templates_tests="Tests/TemplatesTests"
paths_templates_generated="Tests/Fixtures/Generated"

# load selected group
if [ $# -gt 0 ]; then
	key="$1"
else
	echo "error: need group to lint."
	exit 1
fi

selected_path=`eval echo '$'paths_$key`
if [ -z "$selected_path" ]; then
	echo "error: need a valid group to lint."
	exit 1
fi

if [ "$key" = "templates_generated" ]; then
	find "${PROJECT_DIR}/${selected_path}" -name "*.swift" -exec ${PROJECT_DIR}/Scripts/swiftlint_no_disable_all.sh {} \;
else
	"$SWIFTLINT" lint --strict --config "$CONFIG" --path "${PROJECT_DIR}/${selected_path}"
fi
