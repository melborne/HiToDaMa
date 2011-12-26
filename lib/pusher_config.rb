require "pusher"

class PusherConfig
  def self.set(opts)
    Pusher.app_id   = opts[:id]
    Pusher.key      = opts[:key]
    Pusher.secret   = opts[:secret]
    Pusher.instance_eval {
      define_singleton_method(:public)   { "#{opts[:app]}-app" }
      define_singleton_method(:presence) { "presence-#{opts[:app]}-app" }
      define_singleton_method(:private)  { "private-#{opts[:app]}-app" }
    }
  end
end
