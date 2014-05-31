Eye::Rotate
---------

Log rotate for the [Eye](http://github.com/kostya/eye) gem.

## Installation

    gem install eye
    gem install eye-rotate

## Usage

Options:

    :min_size (Fixnum) - set minimal file size for rotate
    :gzip (Boolean) - gzip file or not
    :count (Fixnum) - count of rotated files

Example config: Auto rotate all processes stdall:

```ruby
require 'eye-rotate'

Eye.config do
  log_rotate :every => 3.seconds, :count => 5, :gzip => true
end

Eye.application :app do
  working_dir path
  process :process do
    start_command "ruby -e '1000.times { puts Time.now; $stdout.flush; sleep 0.1 } '"
    daemonize true
    pid_file "1.pid"
    stdall "/tmp/test.log"
  end
end
```

Example config: Manually rotate:

```ruby
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
```

Run:

    bundle exec eye l examples/manual.eye

