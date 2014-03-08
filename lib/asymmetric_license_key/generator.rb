require "openssl"

# Doug Crockford's base32 encoding is more convenient for humans
# see http://www.crockford.com/wrmg/base32.html
require "base32/crockford"

class AsymmetricLicenseKey::Generator

  def self.generate_keypair(bits=1024)
    keypair = OpenSSL::PKey::DSA.new(1024)
    {
      public: keypair.public_key.to_s,
      private: keypair.to_pem
    }
  end

  def initialize(private_key, options={})
    options = {
      digest: OpenSSL::Digest::SHA256.new,
    }.merge(options)
    @keypair = OpenSSL::PKey::DSA.new(private_key)
    @digest = options[:digest]
  end

  def generate_key(user_id)
    message = user_id
    signature = @keypair.sign(@digest, message)
    AsymmetricLicenseKey::Base32::encode_string(signature)
  end
end
