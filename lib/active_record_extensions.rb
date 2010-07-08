#
# © Copyright 2010 Olexiy Zamkoviy. All Rights Reserved.
#
require 'active_record'

ActiveRecord::Base.class_eval do
  def self.validates_as_alnum(field)
    validates_format_of field, :with => /\A[a-zA-Z0-9][-a-zA-Z0-9\s]+\Z/, :message => "should contain at least two symbols and begin with a letter", :if => lambda { |m| m.errors.on(field).nil? }
  end
end
