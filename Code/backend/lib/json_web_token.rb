# Helper class for JWT tokens manipulation
class JsonWebToken

  # Encodes a Hash payload into an encrypted string
  #
  # @param [Hash] payload data to be encoded/encrypted
  # @return [String] encrypted payload
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # Decodes a String token into a Hash of decrypted data
  #
  # @param [String] token encrypted data
  # @return [Hash] decrypted data
  def self.decode(token)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base).first
    HashWithIndifferentAccess.new decoded
  rescue
    nil
  end
end
