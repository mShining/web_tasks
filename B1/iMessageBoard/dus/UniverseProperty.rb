require 'sinatra'
#require 'slim'
#require 'Data_Mapper'
require 'erb'
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
#DataMapper.finalize
require './message'

#Module for Total Information
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
