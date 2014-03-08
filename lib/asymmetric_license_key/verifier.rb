require "openssl"

# Doug Crockford's base32 encoding is more convenient for humans
# see http://www.crockford.com/wrmg/base32.html
require "base32/crockford"

class AsymmetricLicenseKey::Verifier

  def initialize(public_key, options={})
    options = {
      digest: OpenSSL::Digest::SHA256.new,
    }.merge(options)
    @digest = options[:digest]
    @public_key = OpenSSL::PKey::DSA.new(public_key)
  end

  # Verifies whether a license key is valid for a given user_id and
  # the used public key. For in-depth comments on the process have a look
  # at generator.rb
  def verify(user_id, license_key)
    dsa_signature = AsymmetricLicenseKey::Base32.decode_string(license_key)
    return false if dsa_signature.nil?
    message = user_id
    @public_key.verify(@digest, dsa_signature, message)
  end
end
