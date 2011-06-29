require 'bundler/setup'
require 'rspec'

def html_wrap(html)
  "<!DOCTYPE html><html><body>#{html}</body></html>"
end

# Return the last error message on STDERR.
# Prevents the message being output to STDERR.
def last_stderr
  orig_stderr = $stderr
  $stderr = StringIO.new
  yield
  $stderr.rewind
  message = $stderr.string.chomp
  $stderr = orig_stderr
  message
end
