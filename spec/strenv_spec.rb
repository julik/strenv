require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "STRICT_ENV" do
  it 'creates the STRICT_ENV environment variable' do
    is_defined = defined?(STRICT_ENV)
    expect(is_defined).to eq('constant')
  end
  
  context 'STRICT_ENV#[]' do
    it 'proxies calls to [] to ENV' do
      ENV.keys.each do | key |
        expect(STRICT_ENV[key]).to eq(ENV[key])
      end
    end
    
    it 'raises a meaningful error when a nil key is requested' do
      expect {
        STRICT_ENV[nil]
      }.to raise_error(STRICT_ENV::MalformedKey, "The given environment variable name was empty or nil")
    end
    
    it 'raises a meaningful error when an empty key is requested' do
      expect {
        STRICT_ENV['']
      }.to raise_error(STRICT_ENV::MalformedKey, "The given environment variable name was empty or nil")
    end
    
    it 'raises a meaningful error key that does not exist in ENV is requested' do
      totally_random_key = "RANDOM_ENV_KEY_" + SecureRandom.hex(4).upcase
      expect(ENV).not_to have_key(totally_random_key)
      expect {
        STRICT_ENV[totally_random_key]
      }.to raise_error(
        STRICT_ENV::MissingVariable,
        "No environment variable called \"#{totally_random_key}\" - you have to define it"
      )
    end
  end
end

