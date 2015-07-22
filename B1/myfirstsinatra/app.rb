require "sinatra"

class App < Sinatra::Base
  get '/' do
    "hello world!"
  end
end

get '/' do
  "hello world!"
end
