# For now this script doesn't work completely, because:
# - Some of the templates are aimed for Swift 3, so compiling them with Swift 2.2 will fail
# - Some templates require some context, specially for the Storyboards we need to declare
#   XXPickerViewController and CreateAccViewController dummy VC subclasses to be able to compile.
#
# Once we find a clean way to resolve those limitation, we could reactivate the script.
# You could also temporarly activate the script and ignore the errors listed above to check if those
#   are the only errors or if we introduced unrelated errors that needs to be fixed
exit 0


SGTMPDIR=`mktemp -d -t SwiftGen-Templates` || exit 1
for f in `find "${PROJECT_DIR}/UnitTests/expected" -name '*.swift.out'`
do
  TMPFILE="$SGTMPDIR"/`basename $f .out`
  cat $f >"$TMPFILE"
  echo "Checking $TMPFILE template-generated fixture for build errors…"
  xcrun -sdk iphoneos swiftc -parse -target armv7-apple-ios8.0 "$TMPFILE"
done
rm "$SGTMPDIR"