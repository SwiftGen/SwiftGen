if which swiftlint >/dev/null; then
  # Lint generated code in UnitTests/expected
  for f in "${PROJECT_DIR}/UnitTests/expected"/*.swift.out
  do
    cat $f | swiftlint lint --use-stdin | sed s:'<nopath>':"$f":
  done
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
