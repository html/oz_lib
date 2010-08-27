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

  def self.validates_as_alnum_g(field)
    validates_format_of field, :with => /^[-#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}a-zA-Z0-9 ]+$/u, :message => "should contain letters, spaces, dashes or numbers and begin from letter or number", :if => lambda { |m| m.errors.on(field).nil? }
  end

  #
  # Same as validates_as_alnum_g but also allows "`" and "'" symbols
  #
  def self.validates_as_alnum_g_extended(field)
    validates_format_of field, :with => /^[-#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}a-zA-Z0-9 '`]+$/u, :message => "contains wrong characters", :if => lambda { |m| m.errors.on(field).nil? }
  end

  def self.default_value_for(key, val)
    before_validation_on_create do |item| 
      unless item.send(key)               #  unless email_action_type           
        item.send("#{key}=", val)         #    self.email_action_type = 'none'
      end                                 #  end                                   

      true
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

  def self.max_size_of(column, size_val, size_name)
    lambda do |item|
      file = item.send("#{column}_file_object")
      if file
        if File.size(file) > size_val.send(size_name.downcase)
          item.errors.add(column, "size should be less than #{size_val} #{size_name}")
        end
      end
    end
  end

  def self.max_items_count(max_count, options = {})
    lambda do |item|
      count = 
        if options[:scope] 
          if respond_to?(options[:scope])
            send(options[:scope]).count 
          else
            self.count(:conditions => { options[:scope] => item.send(options[:scope]) })
          end
        else
          self.count
        end

      if count >= max_count
        item.errors.add_to_base("Max items count exceeded, can't add another one")
      end
    end
  end

  extend ActiveRecordExtensions::HasAttachedFile
end
