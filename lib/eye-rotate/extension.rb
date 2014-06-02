require_relative "log_rotate"

# Extend config options
class Eye::Dsl::ConfigOpts
  def log_rotate(params = {})
    Eye.application '__default__' do
      check :log_rotate, {:device => :stdall}.merge!(params)
    end
  end
end
