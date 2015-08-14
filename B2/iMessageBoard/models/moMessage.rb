#ActiveRecord架构
#对应数据库表名： mo_messages

require 'mysql2'
require 'active_record'

class MoMessage < ActiveRecord::Base
  
end

=begin
  #本身没意义，只因一个域对应表的一个字段，这样写出来一下子就能看出来表的结构，不用一个个数  =_=
  @mess_id
  @user_id
  @mess
  @created_at
  @author

  class << self
    def add(messid,userid,text,time,author)
      mess = MoMessage.new(:mess_id=>messid,:user_id=>userid,:mess=>text,:created_at=>time,:author=>author)
      mess.save
    end
    def getmess(id)  ####################
	    mess = MoMessage.find_by_mess_id(id)#####
      return mess
    end
    def delete(id)  ####################
	    mess = MoMessage.find_by_mess_id(id)#####
      mess.destroy
    end
  end
=end
