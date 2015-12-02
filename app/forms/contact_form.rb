class ContactForm
  include ActiveModel::Model

  attr_reader :name, :email, :message

  validates :email, presence: true,
                    email: { message: I18n.t(:errors)[:messages][:invalid] }

  validates :name,
            presence: true,
            length: { in: 2..100 }

  validates :message,
            presence: true,
            length: { in: 1..1000 }

  def initialize(contact_params)
    if contact_params
      @name = contact_params[:name]
      @email = contact_params[:email]
      @message = contact_params[:message]
    end
  end

  def run!
    notify_support if valid?
  end

  def notify_support
    ContactMailer.delay.notification(name, email, message)
  end

  # Forms are never themselves persisted
  def persisted?
    false
  end
end
