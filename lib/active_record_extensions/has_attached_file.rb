#
# © Copyright 2010 Olexiy Zamkoviy. All Rights Reserved.
#

module ActiveRecordExtensions
  module HasAttachedFile
    def has_attached_file(file)
      define_method file do
        instance_variable_get("@#{file}")
      end

      define_method "#{file}=" do |f|
        instance_variable_set("@#{file}", Blob.new(
          :blob_owner_id => blob_owner_id,
          :content_type => f.content_type,
          :name => f.original_filename,
          :file => Base64.encode64(f.read)
        ))
      end

      before_save do |item|
        f = item.send(file) 

        if f && item.valid? && ((f.id && f.id == item.send("#{file}_id")) || f.save)
          item.send("#{file}_id=", f.id)
        elsif f && f.errors.errors
          #XXX Finish error handling
        end
      end
    end

    def validates_attachment_presence(file)
      #TODO
      validates_presence_of file
    end

    def validates_attachment_content_type(*args)
      #TODO
    end
  end
end
