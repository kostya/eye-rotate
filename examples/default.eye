require 'eye-rotate'

Eye.config do
  # set log_rotate for all processes, for all stdalls
  log_rotate :every => 3.seconds, :count => 5, :gzip => true
end

Eye.application :app do
  process :process do
    start_command "ruby -e '1000.times { puts Time.now; $stdout.flush; sleep 0.1 } '"
    daemonize true
    pid_file "/tmp/1.pid"
    stdall "/tmp/test.log"
  end
end
