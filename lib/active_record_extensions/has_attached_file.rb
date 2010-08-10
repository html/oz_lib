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

      file_id = "#{file}_id"
      file_size = "#{file}_size" 
      blob_file_object = "blob_#{file}_object"

      unless column_names.include?(file_id)
        raise StandardError, "#{to_s} should have #{file_id} column"
      end

      attr_reader file
      attr_reader "#{file}_file_object"

      define_method "#{file}=" do |f|
        instance_variable_set("@#{file}_file_object", f)
        instance_variable_set("@#{file}", Blob.new(
          :blob_owner_id => blob_owner_id,
          :content_type => f.content_type,
          :name => f.original_filename,
          :file => Base64.encode64(f.read)
        ))
      end

      define_method file_size do
        begin
          if send(file)
            send(file).size
          elsif send(file_id)
            send(blob_file_object).size
          end
        rescue
          nil
        end
      end

      define_method blob_file_object do
        begin
          var = "@#{blob_file_object}" 

          unless instance_variable_get(var) 
            instance_variable_set(var, Blob.find(send(file_id)))
          end

          instance_variable_get(var)
        rescue
          nil
        end
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
