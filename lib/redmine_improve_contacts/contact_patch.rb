
module RedmineImproveContacts
  module ContactPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
       def self.same_contacts
         select('*, LOWER(first_name) AS first_name, LOWER(last_name) AS last_name, count(*) AS count').
             group('first_name, last_name, email').having('count > 1')
       end

       def self.same_contacts_phone
         select('*, LOWER(first_name) AS first_name, LOWER(last_name) AS last_name, count(*) AS count').
             group('first_name, last_name, phone').having('count > 1')
       end
      end
    end

    module InstanceMethods
      def other_same_contacts
        Contact.where("LOWER(first_name) = :first_name AND LOWER(last_name) = :last_name",
                      first_name: self.first_name.to_s.downcase,
                      last_name: self.last_name.to_s.downcase).
            where(email: self.email).
            where.not(id: self.id)
        
      end

      def other_same_contacts_for_phone
        Contact.where("LOWER(first_name) = :first_name AND LOWER(last_name) = :last_name",
                      first_name: self.first_name.to_s.downcase,
                      last_name: self.last_name.to_s.downcase).
            where(phone: self.phone).where.not(id: self.id)

      end
    end
  end
end


unless Contact.included_modules.include?(RedmineImproveContacts::ContactPatch)
  Contact.send(:include, RedmineImproveContacts::ContactPatch)
end