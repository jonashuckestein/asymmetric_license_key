require "base32/crockford"

module AsymmetricLicenseKey::Base32

  # encodes an arbitrary byte string
  def self.encode_string(bytes, options={})
    options = {
      split: 6,
    }.merge(options)

    # Unpack into a binary string such as
    # "0011011110111000011100111111...etc"
    binary_string = bytes.unpack("B*").first

    # Prefix with a 1 to make sure we don't lose bits in conversion to
    # integer
    binary_string.prepend("1")

    # Convert binary string to integer. E.g. "10".to_i(2) == 2
    # ("10".to_i(2) == "010".to_i(2) == 2 is why we need the previous step)
    integer = binary_string.to_i(2)
    Base32::Crockford.encode(integer, options).to_s
  end

  # decodes a crockford base32 string into an arbitrary byte string
  # returns nil if the base32 string is malformed
  def self.decode_string(base32_string)
    integer = Base32::Crockford.decode(base32_string)
    return nil if integer.nil?
    binary_string = integer.to_s(2)
    raise "boom" if binary_string[0] != "1"
    binary_string[0] = "" # remove leading 1
    [binary_string].pack("B*").force_encoding("utf-8")
  end
end
