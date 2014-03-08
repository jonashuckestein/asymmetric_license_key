# Tests basic license key generation and verification.
# This is a little difficult because OpenSSL signatures aren't
# deterministic. If anyone knows how to make these tests 100% deterministic,
# I'm all ears.

require "test_helper.rb"

class AsymmetricLicenseKeyTest < Minitest::Test

  def test_keypair_generation
    keypair = AsymmetricLicenseKey::Generator.generate_keypair(1024)
    assert_match(/^-----BEGIN DSA PRIVATE KEY-----/, keypair[:private])
    assert_match(/^-----BEGIN PUBLIC KEY-----/, keypair[:public])

    keypair = AsymmetricLicenseKey::Generator.generate_keypair(2048)
    assert_match(/^-----BEGIN DSA PRIVATE KEY-----/, keypair[:private])
    assert_match(/^-----BEGIN PUBLIC KEY-----/, keypair[:public])
  end

  def test_1024_bit_keypair
    keypair = AsymmetricLicenseKey::Generator.generate_keypair(1024)
    generator = AsymmetricLicenseKey::Generator.new(keypair[:private])
    license_key = generator.generate_key("some_user@example.com")

    verifier = AsymmetricLicenseKey::Verifier.new(keypair[:public])
    assert(verifier.verify("some_user@example.com", license_key))
    refute(verifier.verify("some_other_user@example.com", license_key))
    refute(verifier.verify("some_user@example.com", license_key+"bogus"))

    invalid_verifier = AsymmetricLicenseKey::Verifier.new(
      AsymmetricLicenseKey::Generator.generate_keypair[:public])

    refute(invalid_verifier.verify("some_user@example.com", license_key))
  end

  def test_2048_bit_keypair
    keypair = AsymmetricLicenseKey::Generator.generate_keypair(2048)
    generator = AsymmetricLicenseKey::Generator.new(keypair[:private])
    license_key = generator.generate_key("waldo@example.com")

    verifier = AsymmetricLicenseKey::Verifier.new(keypair[:public])
    assert(verifier.verify("waldo@example.com", license_key))
    refute(verifier.verify("waldoozo@example.com", license_key))
    refute(verifier.verify("waldo@example.com", "bogus"+license_key))

    invalid_verifier = AsymmetricLicenseKey::Verifier.new(
      AsymmetricLicenseKey::Generator.generate_keypair[:public])

    refute(invalid_verifier.verify("waldo@example.com", license_key))
  end

  def test_different_digest
    keypair = AsymmetricLicenseKey::Generator.generate_keypair(1024)
    generator = AsymmetricLicenseKey::Generator.new(keypair[:private],
      digest: OpenSSL::Digest::DSS1.new)
    license_key = generator.generate_key("some_user@example.com")

    verifier = AsymmetricLicenseKey::Verifier.new(keypair[:public],
      digest: OpenSSL::Digest::DSS1.new)
    assert(verifier.verify("some_user@example.com", license_key))
    refute(verifier.verify("some_other_user@example.com", license_key))
    refute(verifier.verify("some_user@example.com", license_key+"bogus"))

    # wrong digest used
    invalid_verifier = AsymmetricLicenseKey::Verifier.new(keypair[:public])
    refute(invalid_verifier.verify("some_user@example.com", license_key))
  end

  def test_static
    public_key = <<-eos
-----BEGIN PUBLIC KEY-----
MIIBtzCCASwGByqGSM44BAEwggEfAoGBAOos7Z7LY53JGxE+Dp8PvZJEyTUNjY4M
hxyxYxWiTB/VFkF+a9ONuEMILbhoVgXzdWiAwkQX+U2RLZfmItI2OX3vHQ3DGPId
I7FVLjW/QL7TLNlYdQzj5L1GdcBIKE7VyOq53SY133ADAsa9ck73d3axE7YpgweL
R4cxEBQmKEq5AhUA0xDNlnlhGapkCO/NIZyN8H6/Cq0CgYEA3f3dzOsYADjrp1Sr
sjygiqgIJzuFcSWoevTT2aMcNey1cHiZmnJK4bYyP/0OaQ5925XUxqlmrg033diB
VZSALeTY3F7ZRL5rNbGgMtFHyEcmYDuGOXuR8dTOd4blQsx6wcfMmXdjjPZMDAbQ
vdjfdVz08gftI8/KOrJ6xfszKmQDgYQAAoGAV7+96uivQtNKaH3KOPqxVtBKt20+
s+0xbc3c/AjxKyBXDUvTogUsiywhz47AIoc9H6flvOL5Acr2a714Uhnt+0/VfAxN
V6qMUj9Mo7rszs9szly8PUjGONxqP9WhEsbD1oSDZD5MqP5mtzEuxNx6KyaK/YmB
0aoiqfUP5eN6cPs=
-----END PUBLIC KEY-----
eos

    # generated from above keys for waldo@example.com
    license_key = "9G-5G118E-7MQPCS-QJ5R1K-33JQ3R-2N5YPX-MMTEMV-" +
                  "00GM4M-HPH26C-5D7KBD-9Y54AF-HDQX5K-XK7EN7"

    verifier = AsymmetricLicenseKey::Verifier.new(public_key)
    assert(verifier.verify("waldo@example.com", license_key))
  end

  def test_bogus_key
    assert_raises(OpenSSL::PKey::DSAError) {
      AsymmetricLicenseKey::Verifier.new("bogus")
    }
    assert_raises(OpenSSL::PKey::DSAError) {
      AsymmetricLicenseKey::Generator.new("bogus")
    }
  end
end
