
require 'yaml'
require 'time'

#Module for messages
class Message
  attr_accessor :id , :message, :author , :created_at

  @@id=0

  #每次加载Message类时读取全局配置文件中的 id ，保证每次重启应用后留言ID的延续性
  #（在主页显示留言板时为第一次，这保证了这个重要读取是在所有其他操作之前进行的）
  loadfile=YAML.load(File.open("#{File.dirname(__FILE__)}/UniversalProperty.yaml"))
  @@id=loadfile["id"]

  def self.getId
    @@id
  end

  def self.setId=(value)
    @@id = value
  end

######################

	def initialize(ayaml)

    @file_path = ayaml
    yaml = File.new(ayaml).lines.take_while{ |line| !line.strip.empty? }
    @offset = yaml.length
    @options = YAML.load(yaml.join)
	end

  def title
    @options["title"]
  end
  def message
    @options["message"]
  end
  def author
    @options["author"]
  end
  def created_at
    @options['created_at']
  end
  def date
    @options["date"]
  end
  def id
    @options["id"]
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
