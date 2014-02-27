require 'net/http'
#require 'yajl'
#require 'digest/md5'
require 'erb'
require 'rubygems'
gem 'activesupport'
require 'active_support/core_ext/class/attribute_accessors'
 

module Vtiger
  class Mobile < Vtiger::Commands

    def login(options = {})
      self.url = options[:url] || Vtiger::Api.api_settings[:url]
      self.username = options[:username] || Vtiger::Api.api_settings[:username]
      self.access_key = options[:password] || Vtiger::Api.api_settings[:password]
      self.endpoint_url = "http://#{self.url}/modules/Mobile/api.php?"
      input_array = {'_operation'=>'login', 'username'=>self.username, 'password'=>self.access_key} # removed the true
      result = http_crm_post("_operation=login", input_array)
      self.session_name = result["result"]["login"]["session"] if result["result"]!=nil
      self.userid = result["result"]["login"]["userid"] if result["result"]!=nil
      #  puts "session name is: #{self.session_name} userid #{self.userid}"
      self.userid != nil
    end

    def add_object(object_map, hashv, element)
      puts "in add object"
      object_map = object_map.merge hashv
      tmp = self.json_please(object_map)
      input_array = {'_operation' => 'saveRecord', 'module' => "#{element}", '_session' => "#{self.session_name}", 'values'=> tmp} # removed the true
      result = http_crm_post("_operation=saveRecord", input_array)
      success = result['success']
      id = result["result"]["record"]["id"] if success
      return success, id
    end

    def retrieve_object(objid)
      puts "in retrieve object"
      input_array = {'_operation' => 'fetchRecord', '_session' => "#{self.session_name}", 'record' => "#{objid}"}
      result = http_crm_post("_operation=fetchRecord", input_array)
      values = result["result"]
      values
    end

    def updateobject(values, module_name, id)
      puts "in update object"
      object_map = values.to_hash
      tmp = self.json_please(object_map)
      input_array = {'_operation' => 'saveRecord', '_session' => "#{self.session_name}", 'module' => "#{module_name}", 'record' => "#{id}", 'values' => tmp} # removed the true
      result = http_crm_post("_operation=saveRecord", input_array)
    end

  end
  
end
