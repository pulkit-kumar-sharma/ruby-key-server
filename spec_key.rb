require_relative 'key'

RSpec.describe Key do
  let(:key) { Key.new('test_key') }

  describe '#block' do
    it 'blocks the key' do
      key.block
      expect(key.blocked).to be(true)
    end
  end

  describe '#unblock' do
    it 'unblocks the key' do
      key.unblock
      expect(key.blocked).to be(false)
    end

    it 'resets the expiry time' do
      key.unblock
      expect(key.expiry).to be_within(300).of(Time.now + (5 * 60))
    end
  end

  describe '#mark_expired' do
    it 'marks the key as expired' do
      key.mark_expired
      expect(key.expired).to be(true)
    end
  end

  describe '#keep_alive' do
    it 'updates the expiry time' do
      old_expiry = key.expiry
      key.keep_alive
      expect(key.expiry).to be_within(300).of(old_expiry + (5 * 60))
    end
  end

  describe '#valid?' do
    it 'returns true if the key is not expired' do
      expect(key.valid?).to be(true)
    end

    it 'returns false if the key is expired' do
      key.mark_expired
      expect(key.valid?).to be(false)
    end
  end
end
