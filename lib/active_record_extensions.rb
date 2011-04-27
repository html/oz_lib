# coding: utf-8
#
# © Copyright 2010 Olexiy Zamkoviy. All Rights Reserved.
#

require 'active_record'
require 'active_record_extensions/has_attached_file'

ActiveRecord::Base.class_eval do
  ALNUM_RE = /\A[a-zA-Z0-9][-a-zA-Z0-9 ]+\z/u
  IDENTIFIER_RE = /\A[a-zA-Z][a-zA-Z0-9]*\z/u

  # TODO: add tests
  ALNUM_G_RE = /\A[-#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}a-zA-Z0-9 ]+\z/u
  ALNUM_G_EXTENDED_RE = /\A[-#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}a-zA-Z0-9 '`’]+\z/u
  IDENTIFIER_G_RE = /\A[a-zA-Z][-#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}a-zA-Z0-9]+\z/u

  IDENTIFIER_LIST_RE = /\A([a-zA-Z][a-zA-Z0-9]{,99})(,[a-zA-Z][a-zA-Z0-9]{,99}){,9}\z/
  IDENTIFIER_LIST_G_RE = /\A([a-zA-Z][-#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}a-zA-Z0-9]+,)*[a-zA-Z][-#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}a-zA-Z0-9]+\z/u
  URL_RE = /\A(?#Proto)(https?\:\/\/)?(?#Subdomains)([-#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}\w]+\.)+(?#TopLevelDomain)[#{"\xC3\x80-\xC3\x96\xC3\x98-\xC3\xB6\xC3\xB8-\xE1\xBF\xBE"}A-Za-z]{2,}(?#TheRest)\/?[^\r\n]*\z/u

  def self.validates_as_alnum(field)
    validates_format_of field, :with => ALNUM_RE, :message => "should contain at least two symbols and begin with a letter", :if => lambda { |m| m.errors.on(field).nil? }
  end

  def self.validates_as_alnum_g(field)
    validates_format_of field, :with => ALNUM_G_RE, :message => "should contain letters, spaces, dashes or numbers and begin from letter or number", :if => lambda { |m| m.errors.on(field).nil? }
  end

  def self.validates_as_url(field)
    validates_format_of field, :with => URL_RE, :message => "should be valid url", :if => lambda { |m| m.errors.on(field).nil? } 
  end

  #
  # Same as validates_as_alnum_g but also allows "`" and "'" symbols
  #
  def self.validates_as_alnum_g_extended(field)
    validates_format_of field, :with => ALNUM_G_EXTENDED_RE, :message => "contains wrong characters", :if => lambda { |m| m.errors.on(field).nil? }
  end

  def self.validates_as_identifier_list_g(field)
    validates_format_of field, :with => IDENTIFIER_LIST_G_RE, :message => "is invalid", :if => lambda { |m| m.errors.on(field).nil? }
  end

  def self.validates_as_identifier_list(field)
    validates_format_of field, :with => IDENTIFIER_LIST_RE, :message => "is invalid", :if => lambda { |m| m.errors.on(field).nil? }
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
        size = file.respond_to?(:size) ? file.size : File.size(file)
        if size > size_val.send(size_name.downcase)
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
