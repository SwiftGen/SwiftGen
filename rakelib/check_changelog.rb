# frozen_string_literal: true

# This analyze the CHANGELOG.md file and report warnings on its content
#
# It checks:
#  - if the description part of each entry ends with a period and two spaces
#  - that all links to PRs & issues with format [#nn](repo_url/nn) are consistent
#    (use the same number in the link title and URL)
#
# @return Array of Hashes with keys `:line` & `:message` for each element
#
def check_changelog
  current_repo = File.basename(`git remote get-url origin`.chomp, '.git').freeze
  slug_re = '([a-zA-Z]*/[a-zA-Z]*)'
  links = %r{\[#{slug_re}?\#([0-9]+)\]\(https://github.com/#{slug_re}/(issues|pull)/([0-9]+)\)}
  links_typos = %r{https://github.com/#{slug_re}/(issue|pulls)/([0-9]+)}

  all_warnings = []
  inside_entry = false
  last_line_has_correct_ending = false

  File.readlines('CHANGELOG.md').each_with_index do |line, idx|
    line.chomp! # Remove \n the end, it's easier for checks below
    was_inside_entry = inside_entry
    just_started_new_entry = line.start_with?('* ')
    inside_entry = true if just_started_new_entry
    inside_entry = false if /^  \[.*\]\(.*\)$/ =~ line # link-only line

    if was_inside_entry && !inside_entry && !last_line_has_correct_ending
      # We just ended an entry's description by starting the links, but description didn't end with '.  '
      # Note: entry descriptions can be on multiple lines, hence the need to wait for the next line
      # to not be inside an entry to be able to consider the previous line as the end of entry description.
      all_warnings.concat [
        { line: idx, message: 'Line describing your entry should end with a period and 2 spaces.' }
      ]
    end
    # Store if current line has correct ending, for next iteration, so that if the next line isn't
    #   part of the entry description, we can check if previous line ends description correctly.
    # Also, lines just linking to CHANGELOG to other repositories (StencilSwiftKit & Stencil mainly)
    #   should be considered as not needing the '.  ' ending.
    last_line_has_correct_ending = line.end_with?('.  ') || line.end_with?('/CHANGELOG.md)')

    # Now, check that links [#nn](.../nn) have matching numbers in link title & URL
    wrong_links = line.scan(links).reject do |m|
      slug = m[0] || "SwiftGen/#{current_repo}"
      (slug == m[2]) && (m[1] == m[4])
    end
    all_warnings.concat Array(wrong_links.map do |m|
      link_text = "#{m[0]}##{m[1]}"
      link_url = "#{m[2]}##{m[4]}"
      { line: idx + 1, message: "Link text is #{link_text} but links points to #{link_url}." }
    end)

    # Flag common typos in GitHub issue/PR URLs
    typo_links = line.scan(links_typos)
    all_warnings.concat Array(typo_links.map do |_|
      { line: idx + 1, message: 'This looks like a GitHub link URL with a typo. Issue links should use `/issues/123` (plural) and PR links should use `/pull/123` (singular).' }
    end)
  end
  all_warnings
end
