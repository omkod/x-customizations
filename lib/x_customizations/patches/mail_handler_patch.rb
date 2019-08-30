require_dependency 'mail_handler'

module XCustomization
  module Patches
    module MailHandlerPatch
      def self.included(base) # :nodoc:
        Rails.logger.info("XCustomization: MailHandler Patched")
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :add_attachments, :xcustom
        end
      end
      
      module InstanceMethods
        private
        # Fix an issue with winmail.dat files
        def add_attachments_with_xcustom(obj)
          require 'tinnef'
          
          if !email.attachments.nil? && email.attachments.size > 0
            email.attachments.each do |attachment|
              if attachment.filename.include? "winmail.dat" then
                Rails.logger.info("XCustomization: TNEF Attachment processing start" + Setting.plugin_x_customizations['tnef_path'])
                begin  # "try" block
                  Setting.plugin_redmine_bitbucket[:local_path]
                  TNEF.convert(attachment.decoded, :command => Setting.plugin_x_customizations['tnef_path']) do |temp_file|
                    unpacked_content = temp_file.read
                    unpacked_filename = File.basename(temp_file.path)
                    Rails.logger.info("XCustomization: TNEF processsed")
                    single_attachment_add(obj, unpacked_content, unpacked_filename, user, Redmine::MimeType.of(unpacked_filename))
                    Rails.logger.info("XCustomization: TNEF attached")
                  end
                  rescue Exception => ex
                    Rails.logger.error { "XCustomization TNEF mail attachment processing error: #{e}"}
                    single_attachment_add(obj, attachment.decoded, "ATTACHMENT_ERROR_" + attachment.filename, user, attachment.mime_type)
                  break
                end 
                
              else
                Rails.logger.info("XCustomization: NO TNEF processing")
                single_attachment_add(obj, attachment.decoded, attachment.filename, user, attachment.mime_type)              
              end
              Rails.logger.info("XCustomization: Mail attachments PROCESSED.")
            end
          end
        end
        
        def single_attachment_add(obj, file, filename, author, content_type)
          obj.attachments << Attachment.create(:container => obj,
                          :file => file,
                          :filename => filename,
                          :author => author,
                          :content_type => content_type)
        end
        
      end
    end
  end
end

unless MailHandler.included_modules.include?(XCustomization::Patches::MailHandlerPatch)
  MailHandler.send(:include, XCustomization::Patches::MailHandlerPatch)
end
