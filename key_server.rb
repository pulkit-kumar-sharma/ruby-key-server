require_relative 'key'

class KeyServer
  attr_accessor :keys

  def initialize
    @keys = {}
  end

  def generate_key
    key = SecureRandom.hex(16)
    @keys[key] = Key.new(key)
    key
  end

  def valid_key?(key)
    @keys.key?(key) && @keys[key].valid?
  end

  def delete_key(key)
    @keys.delete(key)
  end

  def unblock_key(key)
    return unless valid_key?(key)

    @keys[key].unblock
  end

  def release_blocked_key(key)
    return unless valid_key?(key)

    @keys[key].unblock
  end

  def delete_expired_key(key)
    @keys.delete(key)
  end

  def keep_alive(key)
    return unless valid_key?(key)

    @keys[key].keep_alive
  end
end
