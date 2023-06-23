require_relative 'key_server'

RSpec.describe KeyServer do
  let(:key_server) { KeyServer.new }

  describe '#generate_key' do
    it 'generates a new key' do
      key = key_server.generate_key
      expect(key).not_to be_nil
      expect(key_server.keys[key]).to be_a(Key)
    end
  end

  describe '#valid_key?' do
    it 'returns true for a valid key' do
      key = key_server.generate_key
      expect(key_server.valid_key?(key)).to be(true)
    end

    it 'returns false for an invalid key' do
      expect(key_server.valid_key?('invalid_key')).to be(false)
    end
  end

  describe '#delete_key' do
    it 'deletes the specified key' do
      key = key_server.generate_key
      key_server.delete_key(key)
      expect(key_server.keys[key]).to be_nil
    end
  end

  describe '#unblock_key' do
    it 'unblocks a blocked key' do
      key = key_server.generate_key
      key_server.keys[key].block
      key_server.unblock_key(key)
      expect(key_server.keys[key].blocked).to be(false)
    end

    it 'does nothing for an unblocked key' do
      key = key_server.generate_key
      key_server.unblock_key(key)
      expect(key_server.keys[key].blocked).to be(false)
    end
  end

  describe '#keep_alive' do
    it 'updates the expiry time of a valid key' do
      key = key_server.generate_key
      old_expiry = key_server.keys[key].expiry
      key_server.keep_alive(key)
      expect(key_server.keys[key].expiry).to be_within(300).of(old_expiry + (5 * 60))
    end

    it 'does nothing for an invalid key' do
      key_server.keep_alive('invalid_key')
      expect(key_server.keys['invalid_key']).to be_nil
    end
  end
end
