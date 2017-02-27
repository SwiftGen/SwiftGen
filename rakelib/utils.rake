# run a command, pipe output through 'xcpretty' and store the output in CI artifacts
def xcpretty(cmd, task, subtask = '')
  name = (task.name + (subtask.empty? ? '' : "_#{subtask}")).gsub(/[:-]/, "_")
  command = [*cmd].join(' && ')
  xcpretty = `which xcpretty`

  if ENV['CI']
    sh "set -o pipefail && (#{command}) | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\" | xcpretty --color --report junit --output \"#{ENV['CIRCLE_TEST_REPORTS']}/xcode/#{name}.xml\""
  elsif xcpretty && $?.success?
    sh "set -o pipefail && (#{command}) | xcpretty -c"
  else
    sh command
  end
end

# run a command and store the output in CI artifacts
def plain(cmd, task, subtask = '')
  name = (task.name + (subtask.empty? ? '' : "_#{subtask}")).gsub(/[:-]/, "_")
  command = [*cmd].join(' && ')

  if ENV['CI']
    sh "set -o pipefail && (#{command}) | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\""
  else
    sh command
  end
end

# select the xcode version we want/support
def version_select
  xcodes = `mdfind "kMDItemCFBundleIdentifier = 'com.apple.dt.Xcode' && kMDItemVersion = '8.*'"`.chomp.split("\n")
  if xcodes.empty?
    raise "\n[!!!] You need to have Xcode 8.x to compile SwiftGen.\n\n"
  end
  
  # Order by version and get the latest one
  vers = lambda { |path| `mdls -name kMDItemVersion -raw "#{path}"` }
  latest_xcode_version = xcodes.sort { |p1, p2| vers.call(p1) <=> vers.call(p2) }.last
  %Q(DEVELOPER_DIR="#{latest_xcode_version}/Contents/Developer")
end

# run a command using xcrun and xcpretty if applicable
def xcrun(cmd, task, subtask = '')
  commands = [*cmd].map { |cmd|
    "#{version_select} xcrun #{cmd}"
  }

  if commands.join.match('xcodebuild')
    xcpretty(commands, task, subtask)
  else
    plain(commands, task, subtask)
  end
end

# print an info header
def print_info(str)
  (red,clr) = (`tput colors`.chomp.to_i >= 8) ? %W(\e[33m \e[m) : ["", ""]
  puts red, "== #{str.chomp} ==", clr
end
