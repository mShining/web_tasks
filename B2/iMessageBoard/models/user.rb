#ActiveRecord架构
#对应数据库表名： users

require 'mysql2'
require 'active_record'

class User < ActiveRecord::Base


  class << self

    def auth(name,password)####################
      user = User.find_by_username(name)#####
      if(user == nil)
        return mess = "No-Such-User!"
      elsif(password == user.password)
        return user
      else
        return mess = "Wrong-Password!"
      end
    end

    def isAlreadyExist(name)####################
       user = User.find_by_username(name)#####
       if(user == nil)
         return false
       else
         return true
       end

    end

  end


end
