#Main .rb File in web_tasks/B1 "A Message Board"
#150722 by mShining
#version 2.0(150723)
#version 3.0(150731)
#version 4.0(150803) use activerecord

require 'sinatra'
require 'erb'

#require './message'
#require './manager'

require './models/user'
require './models/moMessage'

#cattr_accessor :ID

#MessageManager = Manager.new  #New一个管理留言类的实例

configure do
  enable :sessions	#启用session
end

dbconfig = YAML::load(File.open(File.dirname(__FILE__)+'/config.yaml'))
ActiveRecord::Base.establish_connection(dbconfig)

###Routes as follow###Total: 12 get: 8 post: 4
##

##登录##
get '/login' do
   erb :"login"
end

post '/login' do  #Use Session
   if(params[:username]==nil||params[:username]=="")
     redirect to("/login?mess=null-username")
   elsif(params[:password]==nil||params[:password]=="")
     redirect to("/login?mess=null-password")
   else
     user=User.auth(params[:username],params[:password])
     if(user == "No-Such-User!" or user == "Wrong-Password!")
      redirect to("/login?mess=#{user}")
     else
	     session['user'] = user
	     session['work'] =TRUE
	     redirect to("/")
     end
   end
end

##主页留言列表##
=begin
get '/' do
	if session[:work] == TRUE
    loadfile=YAML.load(File.open("#{File.dirname(__FILE__)}/UniversalProperty.yaml"))
    @@ID = loadfile["id"]

		@hash = Hash.new
	  @under = []

	  for id in 1..@@ID
      message = MoMessage.getmess(id)
      if (message.class == MoMessage)#中间可能有些ID的留言已经被删除
        @hash[message.mess_id] = message
  	    @under << message.mess_id
      end
    end

	  @under=@under.sort
	  erb :"index", :locals => {:title => "iMessage Board 3.0"}
	else
		redirect to('login')
	end
end
=end
get '/'do
if session[:work] == TRUE
  loadfile=YAML.load(File.open("#{File.dirname(__FILE__)}/UniversalProperty.yaml"))
  @@ID = loadfile["id"]

  @hash = Hash.new
  @under = []

  for id in 1..@@ID
    message = MoMessage.find_by_mess_id(id)
    if (message.class == MoMessage)  #中间可能有些ID的留言已经被删除
      @hash[message.mess_id] = message
      @under << message.mess_id
    end
  end

  @under=@under.sort
  erb :"index", :locals => {:title => "iMessage Board 3.0"}
else
  redirect to('login')
end

end

##留言##
get '/add' do
	thisuser=session['user'].username
	erb :"add",:locals=>{:title => "Add Message" , :thisuser => thisuser
  }
end

post '/add' do
  thisuserid=session['user'].id

	author = params[:author]
	message = params[:message]
	if(author=="" || author ==nil)
	  redirect to("/add?mess=null-author")
	elsif(message.length<10)
	  redirect to("/add?mess=illgal-message")
	else
	  #开始添加操作
    @@ID+=1
    date = DateTime.now
		year = date.year
		month = date.month
		day = date.day
		date = Date.new(year,month,day)
    mess = MoMessage.new(:mess_id=>@@ID,:user_id=>thisuserid,:mess=>params[:message],:created_at=>date.to_s,:author=>params[:author])
    mess.save
    #每添加一次便使全局配置文件中的 id 增加 1 ， 删除时不改变，保证留言ID的唯一性
    hash = {"id" => @@ID}
    File.open("#{File.dirname(__FILE__)}/UniversalProperty.yaml", "wb") {|f| YAML.dump(hash, f) }
	end
	redirect to('/')
end

##注销##
get '/logout' do
   session.clear  #drop Session
   redirect to('/login')
end

##注册##
get '/register' do
   erb :"register"
end

post '/register' do

  if(params[:username] == nil || params[:username]=="")
    redirect to("/register?mess=null-username")
  elsif(User.isAlreadyExist(params[:username]))
    redirect to("/register?mess=User-Already-Exists!")        ##判断是否已存在同名用户，不允许注册
  elsif(params[:password] == nil || params[:password] == "")
    redirect to("/register?mess=null-password")
  elsif(params[:password] != params[:password2])
    redirect to("/register?mess=different-passwords")
  else
    #user=User.add(params[:username],params[:password])        ##实现注册后直接返回主页且为已登录状态
    user = User.new(:username=>params[:username],:password=>params[:password])
    user.save

    session['user'] = user
    session['work'] =TRUE
    redirect to("/")

  end
end

post '/delete' do
  #MessageManager.delete(params[:deleteid])
  message = MoMessage.find_by_mess_id(params[:deleteid])
  MoMessage.delete(params[:deleteid])
  message.destroy
	redirect to("/")
end

##查询##
get '/author' do	#根据作者查找相关留言
  @hash = Hash.new
  @hash.clear
  @under = []

  for id in 1..@@ID
    message = MoMessage.find_by_mess_id(id)
    if (message.class == MoMessage)#中间可能有些ID的留言已经被删除

      #实现模糊搜索
      s=params[:author]
      flag=false
      if(message.author.include?s)  # and s.length>0 实现空查询返回所有留言
        flag=true
      end

  		if(flag)
  	    @hash[message.mess_id] = message
  		  @under << message.mess_id
  		end
    end
  end

  @under = @under.sort
  erb :"search", :locals => {:title => "Search by Author"  }
end

get '/id' do		#根据ID查找相关留言
  @hash = Hash.new
  @hash.clear
  @under = []
  for id in 1..@@ID
    message = MoMessage.find_by_mess_id(id)
    if (message.class == MoMessage)#中间可能有些ID的留言已经被删除

      #实现模糊搜索
      s=params[:id]
      flag=false
      if(message.mess_id.to_s.include?s)  # and s.length>0 实现空查询返回所有留言
        flag=true
      end

  		if(flag)
  	    @hash[message.mess_id] = message
  		  @under << message.mess_id
  		end
    end
  end
  @under=@under.sort
  erb :"search", :locals => {:title => "Search by ID"  }
end

get '/date' do		#根据时间查找相关留言
  @hash = Hash.new
  @hash.clear
  @under = []
  for id in 1..@@ID
    message = MoMessage.find_by_mess_id(id)
    if (message.class == MoMessage)#中间可能有些ID的留言已经被删除

      #实现模糊搜索
      s1=message.created_at.to_s
      s2=params[:date]
      flag=false
      if(s1.include?s2)
        flag=true
      end

  		if(flag)
  	    @hash[message.mess_id] = message
  		  @under << message.mess_id
  		end
    end
  end
  @under=@under.sort
  erb :"search", :locals => {:title => "Search by Date"  }
end

after do
  ActiveRecord::Base.clear_active_connections!
end
