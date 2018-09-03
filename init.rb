Redmine::Plugin.register :redmine_improve_contact do
  name 'Redmine Improve Contact plugin'
  author 'Bilel kedidi'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://www.github.com/bilel-kedidi/redmine_improve_contact'
  author_url 'https://www.github.com/bilel-kedidi'
end
require 'redmine_improve_contacts/contacts_controller_patch'
require 'redmine_improve_contacts/contact_patch'
