class Key
  attr_accessor :key, :blocked, :expiry, :expired

  KEY_EXPIRY_TIME = 300
  KEY_BLOCKED_TIME = 60

  def initialize(key)
    @key = key
    @blocked = false
    @expiry = Time.now + KEY_EXPIRY_TIME
    @expired = false
    expire_key_after_expiry_time
    @blocking_thread_id
  end

  def block
    @blocked = true
    @blocked_time = Time.now + KEY_BLOCKED_TIME
    @blocking_thread_id = release_blocked_key_after_blocked_time
  end

  def unblock
    @blocked = false
    @expiry = Time.now + KEY_EXPIRY_TIME
    puts "Key " + key + " Unblocked"
    kill_thread(@blocking_thread_id)
  end

  def mark_expired
    puts "Key " + key + " Expired"
    @expired = true
  end

  def keep_alive
    @expiry = Time.now + KEY_EXPIRY_TIME
  end

  def valid?
    !@expired
  end

  def release_blocked_key_after_blocked_time
    @thread = Thread.new do
      sleep(@blocked_time - Time.now)
      if(@blocked)
        unblock
      end
    end
    @thread.object_id
  end

  def release_blocked_key_after_blocked_time
    @thread = Thread.new do
      remaining_time = @blocked_time - Time.now
      while remaining_time > 0
        sleep remaining_time
        remaining_time = @blocked_time - Time.now
      end
      if @blocked
        unblock
      end
    end
  end

  def expire_key_after_expiry_time
    @thread = Thread.new do
      remaining_time = @expiry - Time.now
      while remaining_time > 0
        sleep remaining_time
        remaining_time = @expiry - Time.now
      end
      if !@expired
        mark_expired
      end
    end
  end

  def kill_thread(thread_id)
    thread = Thread.list.find { |t| t.object_id == thread_id }
    thread.kill if thread
  end

end
