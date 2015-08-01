require 'sinatra'
#require 'slim'
#require 'Data_Mapper'
require 'erb'
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
#DataMapper.finalize
require './message'

#Controller  for Add and Query (all methods are static)
class Operation


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
