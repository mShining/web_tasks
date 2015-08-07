
require 'yaml'
require 'time'
require './message'


class Manager

	def load(dir, ext="yaml")	#读取yaml文件生成article对象
		@messages ||= Hash.new
		Dir.glob("#{dir}/**/*.#{ext}").each do |file|
			message = Message.new(file)
			if(message.id.to_i>Message.getId)
				Message.setId = message.id
			end
		end
	end


	# Message类 -> yaml文件
	def add(author,message,userid)
    Message.setId = Message.getId + 1

    date = DateTime.now
		year = date.year
		month = date.month
		day = date.day
		date = Date.new(year,month,day)

		#hash = {"author"=> author,"message" => message,"id" => Message.getId,"created_at" => date.to_s }
		#File.open("#{File.dirname(__FILE__)}/messages/#{Message.getId}.yaml", "wb") {|f| YAML.dump(hash, f) }
		#上述两句被替换成以下一句，与数据库的交互
		MoMessage.add(Message.getId,userid,message,date.to_s,author)



    #每添加一次便使全局配置文件中的 id 增加 1 ， 删除时不改变，保证留言ID的唯一性
    hash = {"id" =>Message.getId}
    File.open("#{File.dirname(__FILE__)}/UniversalProperty.yaml", "wb") {|f| YAML.dump(hash, f) }
	end

  def delete(theid)
=begin
    @hash = Hash.new
    @hash.clear
    @under = []
    Dir.glob("#{File.dirname(__FILE__)}/messages/*.yaml").each do |file|
  		message = Message.new(file)
  		if(message.id.to_s == id)
  	          File.delete("messages/#{message.id}.yaml")
  		end
    end
=end

  	message = MoMessage.getmess(theid)
		MoMessage.delete(theid)
		message.destroy

  end

=begin
  def show
    @hash = Hash.new
    @under = []
    Dir.glob("#{File.dirname(__FILE__)}/messages/*.yaml").each do |file|
          message = Message.new(file)
          @hash[message.id] = message
          @under << message.id

        end
    @under=@under.sort
  end
=end

  def getUnder
    @under
  end

  def [](slug)
    @messages[slug]
  end

  def messages
    @messages.values.sort.reverse
  end

end
######################
