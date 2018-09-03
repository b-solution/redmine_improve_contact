namespace :redmine do
  namespace :improve_contacts do
    task :clear => :environment do
      contacts = Contact.same_contacts.group_by{|c| [c.email, c.first_name, c.last_name]}
      contacts.each do |(email, first_name, last_name), primary_contacts|
        next if email.blank?
        contact = primary_contacts.is_a?(Array) ? primary_contacts.first : primary_contacts
        other_contracts = contact.other_same_contacts
        HelpdeskTicket.where(contact_id: other_contracts.pluck(:id)).update_all({contact_id: contact.id})
        other_contracts.delete_all
      end
      contacts = Contact.same_contacts_phone.group_by{|c| [c.phone, c.first_name, c.last_name]}
      contacts.each do |(phone, first_name, last_name), primary_contacts|
        next if phone.blank?
        contact = primary_contacts.is_a?(Array) ? primary_contacts.first : primary_contacts
        other_contracts = contact.other_same_contacts_for_phone
        HelpdeskTicket.where(contact_id: other_contracts.pluck(:id)).update_all({contact_id: contact.id})
        other_contracts.delete_all
      end
    end
  end
end