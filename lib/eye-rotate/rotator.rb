require 'fileutils'
require 'zlib'

# very simple log rotator

def gzip_cmd
  if !`which /bin/gzip`.empty?
    "/bin/gzip"
  elsif !`which gzip`.empty?
    "gzip"
  end
end

def cp_cmd
  if !`which /bin/cp`.empty?
    "/bin/cp"
  elsif !`which cp`.empty?
    "cp"
  end
end

raise "Requires gzip" unless gzip_cmd
raise "Requires cp" unless cp_cmd

module Eye
end

class Eye::Rotator
  # options
  #   :gzip => [true, false]
  #   :min_size => [10 * 1024 * 1024, nil]
  #   :count => 5

  attr_reader :gzip, :min_size, :filename, :options, :count

  def initialize(filename, options = {})
    @filename = File.expand_path(filename)
    @options = options

    @gzip = @options[:gzip]
    @min_size = @options[:min_size]
    @count = @options[:count] || 7
    @count = 1 if @count.to_i < 1
  end

  def rotate_if_needed
    if min_size
      rotate if file_size > min_size
    else
      rotate
    end
  end

private

  def file_size
    File.size(filename) rescue -1
  end

  def name(num)
    s = "#{filename}.#{num}"
    s += ".gz" if gzip
    s
  end

  def rotate
    return unless File.exists?(filename)

    @tmp_name = "#{filename}.tmp#{Time.now.to_f}"

    if gzip
      `#{gzip_cmd} -c '#{filename}' > '#{@tmp_name}'`
    else
      `#{cp_cmd} '#{filename}' '#{@tmp_name}'`
    end

    # truncate filename
    File.truncate(filename, 0)

    # delete last
    FileUtils.rm(name(count)) rescue nil

    # move files
    count.downto(1) { |i| move(i - 1, i) }

    FileUtils.mv(@tmp_name, name(1))
  end

  def move(from_num, to_num)
    FileUtils.mv(name(from_num), name(to_num))
  rescue
  end

end
