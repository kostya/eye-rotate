require 'eye-rotate'

path = File.expand_path(File.dirname(__FILE__) + "/../")

Eye.application :app do
  working_dir path
  process :process do
    start_command "ruby -e '1000.times { puts Time.now; $stdout.flush; sleep 0.1 } '"
    daemonize true
    pid_file "1.pid"
    stdall "test.log"
    check :log_rotate, :filename => "test.log", :every => 3.seconds, :count => 5, :gzip => true
  end
end
