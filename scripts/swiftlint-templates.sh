if which swiftlint >/dev/null; then
  # Lint generated code in UnitTests/expected
  for f in `find "${PROJECT_DIR}/UnitTests/expected" -name '*.swift.out'`
  do
    cat $f | swiftlint lint --use-stdin | sed s:'<nopath>':"$f":
  done
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
