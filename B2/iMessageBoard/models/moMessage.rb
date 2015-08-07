#ActiveRecord架构
#对应数据库表名： moMessages

require 'mysql2'
require 'active_record'

class MoMessage < ActiveRecord::Base
  dbconfig = YAML::load(File.open(File.dirname(__FILE__)+'/../config.yaml'))
  ActiveRecord::Base.establish_connection(dbconfig)

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

=begin #no need
    def delete(id)  ####################
	    mess = MoMessage.find_by_mess_id(id)#####
      mess.destroy
    end
=end

  end
end
