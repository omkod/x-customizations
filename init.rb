require 'x_customizations/patches/mail_handler_patch'

Rails.configuration.to_prepare do
  require_dependency 'x_customizations/patches/application_helper_patch'
end

Redmine::Plugin.register :x_customizations do
  name "X  Customizations"
  author 'Niremizov'
  description 'Plugin with some UI Customizations'
  version 1
  author_url 'mailto:niremizov@omcode.ru'

  requires_redmine :version_or_higher => '3.2'

  settings :default => {'tnef_path' => 'tnef'}, :partial => 'settings/x_customizations'
end
