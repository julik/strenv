module Strenv
  VERSION = '0.0.1'
  MalformedKey = Class.new(RuntimeError)
  MissingVariable = Class.new(RuntimeError)
  
  def [](key)
    key_as_str = key.to_s
    raise MalformedKey, "The given environment variable name was empty or nil" if key_as_str.empty?
    unless ENV.has_key?(key_as_str)
      raise MissingVariable, "No environment variable called #{key_as_str.inspect} - you have to define it" 
    end
    ENV[key]
  end
  
  extend self
end
  
STRICT_ENV = Strenv