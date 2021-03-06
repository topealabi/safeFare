class ContactForm < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :parent
  attribute :restaurant_owner
  attribute :employee
  attribute :member
  attribute :other

  attribute :message, :validate => true
  attribute :zip
  attribute :subject

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "New Contact Form",
      :to => "dhruv.mehrotra@themechanism.com",
      :from => %("#{name}" <#{email}>)
    }
  end
end