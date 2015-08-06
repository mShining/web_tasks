#ActiveRecord架构
#对应数据库表名： users

require 'mysql2'
require 'active_record'

class User < ActiveRecord::Base
  dbconfig = YAML::load(File.open(File.dirname(__FILE__)+'/../config.yaml'))
  ActiveRecord::Base.establish_connection(dbconfig)

  @id
  @username
  @password

  class << self
    def add(name,password)
      user = User.new(:username=>name,:password=>password)
      user.save
    end

    def getuser(name,password)####################
      begin
	       user = User.find_by_username(name)#####
         if(user == nil)
           return mess = "No-Such-User!"
         elsif(password == user.password)
           return user
         else
           return mess = "Wrong-Password!"
         end
      end
    end

  end


end
