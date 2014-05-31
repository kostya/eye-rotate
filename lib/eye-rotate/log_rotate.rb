require_relative "rotator"

Eye::Controller

class LogRotate < Eye::Checker::CustomDefer
  param :filename, [String]
  param :device, [Symbol], nil, nil, [:stdout, :stderr, :stdall]

  param :min_size, [Fixnum]
  param :gzip, [TrueClass, FalseClass]
  param :count, [Fixnum]

  def initialize(*args)
    super

    fname = if filename
      filename
    elsif device && device != :stdall
      process.config[device]
    else
      if process.config[:stdout] != process.config[:stderr]
        [process.config[:stdout], process.config[:stderr]]
      else
        process.config[:stdall]
      end
    end

    @rots = Array(fname).map do |name|
      Eye::Rotator.new(name, {:min_size => min_size, :gzip => gzip, :count => count})
    end
  end

  def get_value
    @rots.each &:rotate_if_needed
    true
  end

  def good?(v)
    true
  end
end
