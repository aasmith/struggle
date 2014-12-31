# -*- ruby -*-

require "rubygems"
require "hoe"

Hoe.spec "struggle" do
  developer("Andrew A Smith", "andy@tinnedfruit.org")

  self.readme_file = "README.md"

  self.extra_rdoc_files = FileList['*.md']

  license ""
  # license "MIT" # this should match the license in the README
end

task :progress do
  done = `grep require lib/struggle/events/card_events.rb | \
          grep -v TODO | wc -l`
  left = `grep TODO lib/struggle/events/card_events.rb | wc -l`

  puts "Event Implementation Progress:"
  puts "Done: %s Remaining: %s" % [done.strip, left.strip]
end

task :console do
  # Rather than run IRB inline, shell out. This produces a cleaner backtrace
  # that excludes rake context when an error is encountered.
  exec "irb -Ilib -rstruggle -EUTF-8"
end

# vim: syntax=ruby
