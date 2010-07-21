# coding: utf-8
#
# © Copyright 2010 Olexiy Zamkoviy. All Rights Reserved.
#

require 'active_record'
require 'active_record_extensions/has_attached_file'

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

  def self.only_jpeg_or_png_images_allowed_for(column)
    lambda do |item|
      if item.send(column)
        unless item.send(column).content_type.match /image\/(?:p?jpe?g|(?:x-)?png)/
          item.errors.add(column, "should be either png or jpeg image")
        end
      end
    end
  end

  extend ActiveRecordExtensions::HasAttachedFile
end
