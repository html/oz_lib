#
# © Copyright 2010 Olexiy Zamkoviy. All Rights Reserved.
#

module ActiveRecordExtensions
  module HasAttachedFile
    def has_attached_file(file)
      unless respond_to?(:blob_owner_id)
        define_method 'blob_owner_id' do
          raise StandardError, "You must define blob_owner_id method returning correct blob owner id before has_attached_file invoking" 
        end
      end

      unless column_names.include?("#{file}_id")
        raise StandardError, "#{to_s} should have #{file}_id column"
      end

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

        if f && item.valid? && (!(f.id && f.id == item.send("#{file}_id")) && f.save)
          if item.send("#{file}_id")
            begin
              Blob.find(item.send("#{file}_id")).destroy
            rescue
            end
          end

          item.send("#{file}_id=", f.id)
        elsif f && f.errors.errors
          f.errors.full_messages.each do |message|
            item.errors.add(file, message)
          end

          false
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
