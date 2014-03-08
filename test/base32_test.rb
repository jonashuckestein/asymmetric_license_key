require "test_helper.rb"

TEST_ENCODINGS = {
  "" => "1",
  "1" => "9H",
  "\0" => "80",
  "0-\x02\x14\x0Fo\xEBd\xD4R*\x13\xE8\xAB\xEF\xB8\xD5\x9FW)V\x10'Z\x02\x15\x00\xD9\xD7o\xB7\x12\x85\f\x010\x87\xC0\xFE\xA5\v\xE3#;\x00\x9FU" => "2C1D-08A0YV-ZBCKA5-4AGKX2-NYZE6N-KXBJJN-GG4XD0-4580V7-BPZDRJ-GM602C-47R3ZA-A2Z34C-XG17TN"
}

class Base32Test < Minitest::Test

  def test_encode_string
    TEST_ENCODINGS.each do |string, encoded_string|
      assert_equal(encoded_string.to_s,
        AsymmetricLicenseKey::Base32.encode_string(string))
    end
  end

  def test_decode_string
    TEST_ENCODINGS.each do |string, encoded_string|
      assert_equal(string.to_s,
        AsymmetricLicenseKey::Base32.decode_string(encoded_string))
    end
  end
end
