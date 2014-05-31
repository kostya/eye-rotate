require 'eye-rotate'

Eye.config do
  logger "/tmp/eye.log"
end

Eye.application :app do
  process :process do
    start_command "ruby -e 'loop { puts Time.now; $stdout.flush; sleep 0.1 } '"
    daemonize true
    pid_file "/tmp/1.pid"
    stdall "/tmp/1.log"
    check :log_rotate, :every => 30.seconds, :count => 5, :gzip => true
  end
end
