# This is both a constant and a module, since in Ruby those two
# often go together. We avoid an extra item in the namespace
# and an extra assignment.
module STRICT_ENV
  VERSION = '0.0.2'
  MalformedKey = Class.new(RuntimeError)
  MissingVariable = Class.new(RuntimeError)
  
  # Fetch a value from ENV coded by "key" and raise a meaningful error if it's not set.
  def [](key)
    key_as_str = key.to_s
    raise MalformedKey, "The given environment variable name was empty or nil" if key_as_str.empty?
    unless ENV.has_key?(key_as_str)
      raise MissingVariable, "No environment variable called #{key_as_str.inspect} - you have to define it" 
    end
    ENV[key]
  end
  
  # Run a block protecting the contents of the environment variables. This is especially useful for
  # tests/specs that excercise methods that depend on environment variable state.
  # Use this as a wrapper block in "around" aspects. For example, for RSpec:
  #
  #   RSpec.configure do |c|
  #     c.around(:each) do |example|
  #       STRICT_ENV.with_protected_env { example.run }
  #     end
  #   end
  # 
  # Note that this may play up with your editor features if it mutates environment variables
  # based on the position in the script and it runs in the same environment as your objects
  # under test (TextMate does this).
  def with_protected_env(&blk)
    preserved = ENV.to_h.dup
    yield
  ensure
    ENV.replace(preserved)
  end
  
  extend self
end

