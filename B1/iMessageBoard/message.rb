
#require 'sinatra'
require 'yaml'
require 'time'

#Module for messages
class Message#Normally used in read-and-show process
  attr_accessor :id , :message, :author , :created_at
	@@id=0

	# yaml文件 -> Message对象
	def self.load(dir, ext="yaml")
		@messages ||= Hash.new
		Dir.glob("#{dir}/**/*.#{ext}").each do |file|
			article = Message.new(file)
			@@id = @@id+1
			@messages[message.id] = message
		end
	end

	# Message类 -> yaml文件
	def self.add(author,message,title)
		@@id += 1
		d = DateTime.now

		year = d.year
		month = d.month
		day = d.day
		d = Date.new(year,month,day)

		hash = {"author"=> author,"message" => message,"id" =>@@id,"created_at" =>d.to_s }
		File.open("#{File.dirname(__FILE__)}/messages/#{@@id}.yaml", "wb") {|f| YAML.dump(hash, f) }
	end

	def self.delete
			@@id= (@@id==0) ? 0 : @@id-1
	end

  def self.[](slug)
    @messages[slug]
  end

  def self.messages
    @messages.values.sort.reverse
  end

######################

	def initialize(ayaml)
=begin
		text = File.readlines(atxt)  #Normally , load /message/**.txt
		@id = text[0].split(":")[1]
		@author = text[1].split(":")[1]
		@created_at = text[2].split(":")[1]
		@message = text[3].split(":")[1]
=end
		@file_path = ayaml
    yaml = File.new(ayaml).lines.take_while{ |line| !line.strip.empty? }
    @offset = yaml.length
    @options = YAML.load(yaml.join)
	end

  %w(title message author created_at date id).each do |m|
    class_eval "def #{m};@options['#{m}'];end"
  end



  def [](key)
    @options[key.to_s]
  end

  def slug
    File.basename(@file_path, ".*")
  end

  def <=>(article)
    self.date <=> message.date
  end

  def path
    date = @options['created_at']
    if slug.start_with? date.strftime("%F")
      slug.split("-",4).join("/")
    else
      "/#{date.strftime("%Y/%m/%d")}/#{slug}"
    end
  end

  def to_hash
    Hash[%w(title date author body).map{ |key| [key.intern, self.send(key)] }]
  end

  def url
    path
  end

end
