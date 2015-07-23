#Main .rb File in web_tasks/B1 "A Message Board"
#150722 by mShining
#version 2.0(150723)

require 'sinatra'
#require 'slim'
#require 'Data_Mapper'
require 'erb'
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
#DataMapper.finalize



###Classes as follow###Total:3
#Module for messages
class Message#Normally used in read-and-show process
	attr_reader :id , :author , :created_at
  attr_accessor :message
	def initialize(atxt)
		text = File.readlines(atxt)  #Normally , load /message/**.txt
		@id = text[0].split(":")[1]
		@author = text[1].split(":")[1]
		@created_at = text[2].split(":")[1]
		@message = text[3].split(":")[1]
	end
end

#Module for Tatal Information
class UniversalProperty
	attr_accessor :id , :current, :authorInfo, :isEmpty
	def initialize(file)
		content = File.readlines(file)
		@id = content[0].split(":")[1].chomp
		if content[1].class!=NilClass&&content[1]!="\n"
			@isEmpty = false
			@current = content[1].chomp.split(",")
			content = content[2..-1].join.split("<author>")[1..-1]
			@authorInfo = {}
			content.each do |i|
				@authorInfo[i.split("\n")[1]] = i.split("\n")[2].split(",")
			end
		else
			@isEmpty = true
			text = File.open("UniversalProperty.txt","a")
			text.puts"id:0"
			text.close
			@current = []
			@authorInfo = {}
		end
	end
end

#Controller  for Add and Query (all methods are static)
class Operation
	def self.add(author, message)
		info = UniversalProperty.new("UniversalProperty.txt")
		id = info.id.to_i + 1
		if info.isEmpty
			current = [id]
			authorInfo={}
			authorInfo[author]=[id]
		else
			current = info.current<<[id]
			authorInfo = info.authorInfo
			if authorInfo.has_key?(author)
				authorInfo[author]<<[id]
			else
				authorInfo[author]=[id]
			end
		end
		#Add to /message/**.txt
		file = File.open(File.join("messages","#{id}.txt"),"w+")
		file.puts "<id>:#{id}"
		file.puts "<author>:#{author}"
		file.puts "<created_at>:"+Time.now.to_s
		file.puts "<message>:#{message}"
		file.close
		#Update to ./UniversalProperty.txt
		file = File.open("UniversalProperty.txt","w")
		file.puts "id:#{id}"
		file.puts current.join(",")
		authorInfo.each do |key,value|
			file.puts"<author>"
			file.puts key
			file.puts value.join(",")
		end
		file.close
		return id
	end

	def self.queryID(id)
		info = UniversalProperty.new("UniversalProperty.txt")
		if info.current.include?(id)
			return id
		else
			return 404
		end
	end

	def self.queryAuthor(author)
		info = UniversalProperty.new("UniversalProperty.txt")
		if info.authorInfo.has_key?(author)
			return info.authorInfo[author]
		else
			return 404
		end
	end

	def self.delete(id)
		info=UniversalProperty.new("UniversalProperty.txt")
		text=File.readlines("UniversalProperty.txt")
		text1=File.open("TEMP.txt","w+")
		num=info.id.to_i
		num=num - 1
		text1.puts "<id>:#{num}"

		for i in 1..(num)
			text1.print i
			text1.print ","
		end
		text1.puts ""
		for i in 2..(num * 3 + 1)
			text1.puts text[i]
		end
		text1.close()
		File.delete("UniversalProperty.txt")
		File.rename("TEMP.txt","UniversalProperty.txt")
		File.delete("messages/#{num+1}.txt")
	end

end


###Routes as follow###Total: 3 get: 2 post: 2
get '/' do
	#@title = "Index"
	if params[:select]=='author'
		author = params[:value]
		authorInfo = UniversalProperty.new("UniversalProperty.txt").authorInfo
		if authorInfo.has_key?(author)
			@info = authorInfo[author].reverse
		else
			@info = []
			@error = "No such messages written by this author!"
		end
	elsif params[:select]=='id'
		id = params[:value]
		@info = UniversalProperty.new("UniversalProperty.txt").current
		if @info.include?(id)
			@info = [id]
		else
			@info = []
			@error = "No such messages with this ID!"
		end
	else
		@info = UniversalProperty.new("UniversalProperty.txt").current
		if @info.class!=NilClass
			@info = @info.reverse
		end
	end
  erb :index
end

post '/' do
	id = params[:id]
	Operation.delete(id)
	#sinatra.refresh()       isWrong
	#need to refresh the page here , haven't found the method yet
	#todo
	erb :index
end

get '/add' do
	#@title = "Leave Message>>"
	erb :add
end

post '/add' do
	#@title = "Leave Message>>"
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
end
