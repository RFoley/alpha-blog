class User < ApplicationRecord
  # Why use complex regex when you can use confirmation emails?
  VALID_EMAIL_REGEX = /.+@.+\..+/i

  has_many :articles

  before_save { self.email = email.downcase }

  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    length: { maximum: 105 }, format: { with: VALID_EMAIL_REGEX }
end
