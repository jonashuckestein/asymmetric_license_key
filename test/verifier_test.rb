require "minitest/autorun"
require "asymmetric_license_key"

class VerifierTest < Minitest::Test
  def test_initialize

    keypair = AsymmetricLicenseKey::Generator.generate_keypair(1024)

    generator = AsymmetricLicenseKey::Generator.new(keypair[:private])
    verifier = AsymmetricLicenseKey::Verifier.new(keypair[:public])

    user_id = "oskar@email.com"

    license_key = generator.generate_key(user_id)

    assert_equal(true, verifier.verify(user_id, license_key))
  end
end
