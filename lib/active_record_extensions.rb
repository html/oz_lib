# coding: utf-8
#
# © Copyright 2010 Olexiy Zamkoviy. All Rights Reserved.
#

require 'active_record'

ActiveRecord::Base.class_eval do
  def self.validates_as_alnum(field)
    validates_format_of field, :with => /\A[а-яА-Яa-zA-Z0-9][-а-яА-Яa-zA-Z0-9\s]+\Z/u, :message => "should contain at least two symbols and begin with a letter", :if => lambda { |m| m.errors.on(field).nil? }
  end

  def self.default_value_for(key, val)
    before_validation_on_create do |item| 
      unless item.send(key)               #  unless email_action_type           
        item.send("#{key}=", val)         #    self.email_action_type = 'none'
      end                                 #  end                                   
    end
  end
end
