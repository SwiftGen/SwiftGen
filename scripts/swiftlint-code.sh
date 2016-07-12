if which swiftlint >/dev/null; then
  # Lint SwiftGen's source itself
  swiftlint lint --path "${PROJECT_DIR}/swiftgen-cli"
  swiftlint lint --path "${PROJECT_DIR}/GenumKit"
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
