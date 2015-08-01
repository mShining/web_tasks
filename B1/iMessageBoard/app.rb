#Main .rb File in web_tasks/B1 "A Message Board"
#150722 by mShining
#version 2.0(150723)

require 'sinatra'
#require 'slim'
#require 'Data_Mapper'
require 'erb'
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
#DataMapper.finalize
require './message'

helpers do
  def messages
    Message.message
  end
end

set :title => "iMessage Board 3.0"


###Routes as follow###Total: 3 get: 2 post: 2
##
get '/' do
	#@title = "Index"
	@hash = Hash.new
  @under = []
  Dir.glob("#{File.dirname(__FILE__)}/messages/*.yaml").each do |file|
        message = Message.new(file)
        @hash[message.id] = message
        @under << message.id

      end
  @under=@under.sort
  erb :"index", :locals => {
		:title => settings.title}
end

##
get '/add' do
	#@title = "Leave Message>>"
	erb :"add",:locals=>{:title => "[Add Message]"}
end

post '/add' do
	#@title = "Leave Message>>"
=begin
	@error = ""
	if params[:author].nil? or params[:author]==''""
		@error= "Null Author!"
	end
	if params[:message].nil? or params[:message]==''""
		@error= "Null Message!"
	end
	if params[:message].length<10
		@error= "Illgal Message(<10 char)!"
	end
	if @error==''
		@error="Succeed in adding!"
		author = params[:author]
		message = params[:message]
		result = Operation.add(author,message)
	end
	erb :add
=end
	author = params[:author]
	message = params[:message]
	if(author=="" || author ==nil)
	redirect to("/add?mess=[nullauthor]")
	elsif(message.length<10)
	redirect to("/add?mess=illgalmessage")
	else
	Message.add(params[:author],params[:message])
	end
	redirect to('/')
end

post '/delete' do
  @hash = Hash.new
  @hash.clear
  @under = []
  Dir.glob("#{File.dirname(__FILE__)}/messages/*.yaml").each do |file|
		message = Message.new(file)
		if(message.id.to_s == params[:id])
	          File.delete("messages/#{message.id}.yaml")
		  Message.delete
		elsif(message.id > params[:id].to_i)
		   @hash[message.id] = message
	           @under << message.id
		end
  end

	if(@under.length>0)
    @under = @under.sort
    i=0
    while(i<@under.length)
      message2 = @hash[@under[i]]
			newid = message2.id-1
			hash = {"author"=> message2.author,"message" => message2.message,"id" =>newid,"title" => message2.title,"created_at" =>message2.created_at }
			File.open("#{File.dirname(__FILE__)}/messages/#{newid}.yaml", "wb") {|f| YAML.dump(hash, f) }
			File.delete("#{File.dirname(__FILE__)}/messages/#{article2.id}.yaml")
    	i+=1
    end
  end
	redirect to("/?message=1")
end

get '/author' do	#根据作者查找相关留言
  @hash = Hash.new
  @hash.clear
  @under = []
  Dir.glob("#{File.dirname(__FILE__)}/messages/*.yaml").each do |file|
    message = Message.new(file)
		if(message.author == params[:author])
	          @hash[message.id] = message
		  @under << message.id
		end
  end
  @under = @under.sort
  erb :"author", :locals => {
    :title => settings.title
  }
end

get '/id' do		#根据时间查找相关留言
  @hash = Hash.new
  @hash.clear
  @under = []
  Dir.glob("#{File.dirname(__FILE__)}/messages/*.yaml").each do |file|
	  message = Message.new(file)
	  if(message.id.to_s == params[:id])
	    @hash[message.id] = message
	    @under << message.id
	  end
	end
  @under=@under.sort
  erb :"author", :locals => {
    :title => settings.title
  }
end

get '/date' do		#根据时间查找相关留言
  @hash = Hash.new
  @hash.clear
  @under = []
  Dir.glob("#{File.dirname(__FILE__)}/messages/*.yaml").each do |file|
	  message = Message.new(file)
	  if(message.created_at.to_s == params[:date])
	    @hash[message.id] = message
	    @under << message.id
	  end
	end
  @under=@under.sort
  erb :"author", :locals => {
    :title => settings.title
  }
end
