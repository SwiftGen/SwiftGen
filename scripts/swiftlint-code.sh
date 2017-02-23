if which swiftlint >/dev/null; then
  # Lint SwiftGen's source itself
  swiftlint lint --no-cache --strict --path "${PROJECT_DIR}/SwiftGen"
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
