
module RedmineImproveContacts
  module ContactControllerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :create, :check_existed_contacts
      end
    end

    module InstanceMethods
      def create_with_check_existed_contacts
        @contact = Contact.new(:project => @project, :author => User.current)
        @contact.safe_attributes = params[:contact]
        @contact.save_attachments(params[:attachments] || (params[:contact] && params[:contact][:uploads]))
        unless ['.', 'n/a'].include?( @contact.first_name) or ['.', 'n/a'].include?( @contact.last_name)
          if contacts = @contact.other_same_contacts and contacts.present?
            @contact = contacts.first
            @contact_exist = true
          elsif contacts = @contact.other_same_contacts_for_phone and contacts.present?
            @contact = contacts.first
            @contact_exist = true
          end
        end
        if @contact.save
          flash[:notice] = l(:notice_successful_create)
          attach_avatar
          respond_to do |format|
            format.html { redirect_to (params[:continue] ?  {:action => "new", :project_id => @project} : {:action => "show", :project_id => @project, :id => @contact} )}
            format.js
            format.api { redirect_on_create(params) }
          end
        else
          respond_to do |format|
            format.api  { render_validation_errors(@contact) }
            format.js { render :action => "new" }
            format.html { render :action => "new" }
          end
        end
      end
    end
  end
end


unless ContactsController.included_modules.include?(RedmineImproveContacts::ContactControllerPatch)
  ContactsController.send(:include, RedmineImproveContacts::ContactControllerPatch)
end