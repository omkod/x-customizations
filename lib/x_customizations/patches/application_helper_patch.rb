require_dependency 'application_helper'

module XCustomization
  module Patches
    module ApplicationHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :avatar, :xcustom
        end
      end

      module InstanceMethods

        # Adds avatar for Anonymous users.
        def avatar_with_xcustom(user, options = { })
          options[:width] = options[:size] || "50" unless options[:width]
          options[:height] = options[:size] || "50" unless options[:height]
          options[:size] = "#{options[:width]}x#{options[:height]}" if ActiveRecord::VERSION::MAJOR >= 4

          if user.blank? || user.is_a?(String) || (user.is_a?(User) && user.anonymous?)
            return image_tag('anonymous.png', options.merge({:plugin => "x_customizations", :class => "gravatar"}))
          end

          return avatar_without_xcustom(user, options)
        end

      end
    end
  end
end

unless ApplicationHelper.included_modules.include?(XCustomization::Patches::ApplicationHelperPatch)
  ApplicationHelper.send(:include, XCustomization::Patches::ApplicationHelperPatch)
end
