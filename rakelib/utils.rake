# Used constants:
# none

class Utils
  # formatter types
  :xcpretty   # pass through xcpretty and store in artifacts
  :raw        # store in artifacts
  :to_string  # run using backticks and return output

  # run a command using xcrun and xcpretty if applicable
  def self.run(cmd, task, subtask = '', xcrun: false, formatter: :raw)
    commands = xcrun ? [*cmd].map { |cmd|
      "#{version_select} xcrun #{cmd}"
    } : [*cmd]

    case formatter
    when :xcpretty then xcpretty(commands, task, subtask)
    when :raw then plain(commands, task, subtask)
    when :to_string then `#{commands.join(' && ')}`
    else raise "Unknown formatter '#{formatter}'"
    end
  end

  # print an info header
  def self.print_info(str)
    (red,clr) = (`tput colors`.chomp.to_i >= 8) ? %W(\e[33m \e[m) : ["", ""]
    puts red, "== #{str.chomp} ==", clr
  end

  ## [ Private helper functions ] ##################################################

  # run a command, pipe output through 'xcpretty' and store the output in CI artifacts
  def self.xcpretty(cmd, task, subtask)
    name = (task.name + (subtask.empty? ? '' : "_#{subtask}")).gsub(/[:-]/, "_")
    command = [*cmd].join(' && ')

    if ENV['CI']
      Rake.sh "set -o pipefail && (#{command}) | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\" | bundle exec xcpretty --color --report junit --output \"#{ENV['CIRCLE_TEST_REPORTS']}/xcode/#{name}.xml\""
    elsif system('which xcpretty > /dev/null')
      Rake.sh "set -o pipefail && (#{command}) | bundle exec xcpretty -c"
    else
      Rake.sh command
    end
  end
  private_class_method :xcpretty

  # run a command and store the output in CI artifacts
  def self.plain(cmd, task, subtask)
    name = (task.name + (subtask.empty? ? '' : "_#{subtask}")).gsub(/[:-]/, "_")
    command = [*cmd].join(' && ')

    if ENV['CI']
      Rake.sh "set -o pipefail && (#{command}) | tee \"#{ENV['CIRCLE_ARTIFACTS']}/#{name}_raw.log\""
    else
      Rake.sh command
    end
  end
  private_class_method :plain

  # select the xcode version we want/support
  def self.version_select
    xcodes = `mdfind "kMDItemCFBundleIdentifier = 'com.apple.dt.Xcode' && kMDItemVersion = '8.*'"`.chomp.split("\n")
    if xcodes.empty?
      raise "\n[!!!] You need to have Xcode 8.x to compile SwiftGen.\n\n"
    end
    
    # Order by version and get the latest one
    vers = lambda { |path| `mdls -name kMDItemVersion -raw "#{path}"` }
    latest_xcode_version = xcodes.sort { |p1, p2| vers.call(p1) <=> vers.call(p2) }.last
    %Q(DEVELOPER_DIR="#{latest_xcode_version}/Contents/Developer")
  end
  private_class_method :version_select

end
