class Contact < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }

  validates :inquiry, presence: true, length: { minimum: 3, maximum: 100 }

  validates :name, presence: true, length: { minimum: 3, maximum: 50 }

  validates :email, presence: true,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
            length: { minimum: 3, maximum: 200 }

  validates :phone, presence: true, length: { minimum: 10, maximum: 12 }

  validates :subject, presence: true, length: { minimum: 5, maximum: 50 }

  validates :body, presence: true, length: { minimum: 15, maximum: 100000 }


  before_save :format_fields # @private

  private

    def format_fields
      self.inquiry = inquiry.parameterize
      self.phone = phone.gsub(/\D/, '')
    end
end
