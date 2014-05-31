require "bundler/setup"
Bundler.require
require 'eye-rotate/rotator'

TEST_FILE = File.expand_path(File.dirname(__FILE__) + "/test.log")

def test_content(size = 1000)
  "a" * size
end

def create_test_file(size = 1000)
  File.open(TEST_FILE, 'w') { |f|
    f.write(test_content(size))
  }
end

def clear_test_files
  Dir[TEST_FILE + "*"].each do |f|
    FileUtils.rm(f)
  end
end

def file(num = nil)
  unless num
    File.read(TEST_FILE)
  else
    File.read(TEST_FILE + ".#{num}")
  end
rescue
  -1
end

def filegz(num = nil)
  unless num
    File.read(TEST_FILE)
  else
    content = ""
    Zlib::GzipReader.open(TEST_FILE + ".#{num}.gz") do |gz|
      content = gz.read
    end
    content
  end
rescue
  -1
end

def fixture(name)
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', name))
end

Eye::Logger.link_logger(File.join(File.dirname(__FILE__), ["spec.log"]))
Celluloid.logger = Eye::Logger.inner_logger

RSpec.configure do |config|
  config.before { Celluloid.boot; clear_test_files }
  config.after { Celluloid.shutdown; clear_test_files }
end
