class Account < ApplicationRecord
  has_secure_password

  enum status: {
    active: 'active',
    inactive: 'inactive',
    banned: 'banned'
  }

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { in: 3..32 },
            format: {
              with: /\A[a-zA-Z0-9_]+\z/,
              message: 'can only contain letters, numbers, and underscores'
            }

  validates :password,
            presence: true,
            length: { minimum: 12 },
            if: -> { new_record? || password.present? }

  validate :password_complexity

  private

  def password_complexity
    return if password.blank?

    unless password.match?(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])/)
      errors.add(:password, 'must include at least one lowercase letter, one uppercase letter, one digit, and one special character')
    end
  end
end