class AsymmetricLicenseKey::Key
  def initialize(user_id, public_key, private_key)
    @user_id = user_id
    @license_key = "123-#{user_id}-test"
  end

  def to_s
    @license_key
  end
end
