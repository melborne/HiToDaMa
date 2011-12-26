require_relative "lib/pusher_config"

configure do
  CONF = YAML.load_file('myprofile')
  APP_TITLE = "HiToDaMa"
  BLOG = {title: "hp12c", url: "http://d.hatena.ne.jp/keyesberry"}
end

configure :production do
  PusherConfig.set({app: APP_TITLE}.merge CONF[:PusherDevConfig])
end

configure :development do
  PusherConfig.set({app: APP_TITLE}.merge CONF[:PusherDevConfig])
  disable :logging
end

get '/' do
  haml :index
end

post '/pusher/auth' do
  id, channel = params[:socket_id], params[:channel_name]
  Pusher[channel].authenticate(id, :user_id => id).to_json
end

get '/style.css' do
  scss :style
end

