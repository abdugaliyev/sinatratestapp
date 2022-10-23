require "sinatra/base"
require "sinatra/reloader" if development?
require "whatsapp_sdk"

class WhatsAppBot < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
    enable :sessions
    set :session_secret, "40522941616dae0540d8cac4402f69776b057bf6ae77389f583ecfae74fe6b05"
    # set :session_store, Rack::Session::Pool
  end

  client = WhatsappSdk::Api::Client.new("yourtokenhere") # replace this with a valid access token
  messages_api = WhatsappSdk::Api::Messages.new(client)

  get '/' do
    "Hello World!"
  end

  get '/bot' do
    "Hello World"
    puts "work"
    puts params['hub.challenge']
    params['hub.challenge'] # facebook verification
  end

  post '/bot' do
    request.body.rewind
    body = JSON.parse request.body.read
    
    if body['entry'][0]['changes'][0]['value'].include?("messages")
      
      puts body
      user_text = body['entry'][0]['changes'][0]['value']['messages'][0]['text']['body']
      
      case
      when user_text == "hi"
        session[:message] = 'Hello World!' # set the session
        # puts session[:answer
        messages_api.send_text(sender_id: "yoursenderhere", recipient_number: "yournumberhere", message: "hola")

        puts response

      when user_text == "ok"

        messages_api.send_text(sender_id: "yoursenderhere", recipient_number: "yournumberhere", message: "ok")
        
        puts session[:message] # its doesnt work!

        puts response

      end
    end
  end
end