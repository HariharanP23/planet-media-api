class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :status, presence: true
  validates :due_date, presence: true
  validate :validate_due_date

  enum status: { pending: 0, in_progress: 1, completed: 2 }

  private
  def validate_due_date
    return if due_date.blank?

    if due_date < Date.today
      errors.add(:due_date, "must be in the future")
    elsif !due_date.is_a?(Date)
      errors.add(:due_date, "must be a valid date")
    end
  end
end
