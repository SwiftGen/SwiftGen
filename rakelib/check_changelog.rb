# @return Array of Hashes with keys `:line` & `:message` for each element
#
def check_changelog
  current_repo = File.basename(`git remote get-url origin`.chomp, '.git').freeze
  slug_re = '([a-zA-Z]*/[a-zA-Z]*)'
  links = %r{\[#{slug_re}?\#([0-9]+)\]\(https://github.com/#{slug_re}/(issues|pull)/([0-9]+)\)}
  all_warnings = []
  inside_entry = false
  last_line_has_correct_ending = false
  File.readlines('CHANGELOG.md').each_with_index do |line, idx|
    line.chomp!
    was_inside_entry = inside_entry
    just_started_new_entry = line.start_with?('* ')
    inside_entry = true if just_started_new_entry
    inside_entry = false if /^  \[.*\]\(.*\)$/ =~ line # link-only line

    # We just ended an entry's description by starting the links, but description didn't end with '.  '
    wrong_line_end = was_inside_entry && !inside_entry && !last_line_has_correct_ending

    all_warnings.concat [
      { line: idx, message: 'line describing your entry should end with a period and 2 spaces.' }
    ] if wrong_line_end
    last_line_has_correct_ending = line.end_with?('.  ') || line.end_with?('/CHANGELOG.md)')

    wrong_links = line.scan(links).reject do |m|
      slug = m[0] || "SwiftGen/#{current_repo}"
      (slug == m[2]) && (m[1] == m[4])
    end
    all_warnings.concat Array(wrong_links.map do |m|
      { line: idx+1, message: "link text is #{m[0]}##{m[1]} but links points to #{m[2]}##{m[4]}." }
    end)
  end
  all_warnings
end