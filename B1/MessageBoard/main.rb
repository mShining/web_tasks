require 'sinatra'
#require 'slim'
#require 'data_mapper'
require 'erb'

#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Message
  #include DataMapper::Resource
  @@total="fuck"
  attr_reader :id, :author, :created_at
  attr_accessor :message
  @id=0 ,          :Serial               # , :required => true
  @message
  #@ author ,         String
  #@created_at , Time

  def initialize(message , author)
    @message=message
    @author=author
    @created_at=Time.now
    return
  end

  def addMessage()
    m1=Message.new(message, author)
    return m1.id
  end

  def deleteMessage(id)

  end

  def getMseeage

  end
end
#DataMapper.finalize

Message.total = "you"

get '/' do
  @messages=Message.total
  erb :index
end

post '/' do
  Message.create  params[:message]
  redirect to('/')
end

get '/:task' do
  @task = params[:task].split('-').join(' ').capitalize
  slim :task
end


delete '/task/:id' do
  Message.get(params[:id]).destroy
  redirect to('/')
end

put '/task/:id' do
  task = Message.get params[:id]
  task.completed_at = task.completed_at.nil? ? Time.now : nil
  task.save
  redirect to('/')
end
