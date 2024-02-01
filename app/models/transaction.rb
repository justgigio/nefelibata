class Transaction < ApplicationRecord
  validates :transaction_id, numericality: { only_integer: true, greater_than: 0 }
  validates :merchant_id, numericality: { only_integer: true, greater_than: 0 }
  validates :user_id, numericality: { only_integer: true, greater_than: 0 }
  validates :card_number, presence: true, format: { with: /\A\d{6}\*+\d{2,5}\z/, message: "must be in 000000******0000 format" }
  validates :transaction_date, presence: true
  validates :transaction_amount, numericality: { only_integer: true, greater_than: 0 }

  def is_authentic_duplication?(transaction_dict)
    match = true
    match = match && self.transaction_id == transaction_dict[:transaction_id]
    match = match && self.merchant_id == transaction_dict[:merchant_id]
    match = match && self.user_id == transaction_dict[:user_id]
    match = match && self.card_number == transaction_dict[:card_number]
    match = match && self.transaction_date == DateTime.parse(transaction_dict[:transaction_date])
    match && self.transaction_amount == transaction_dict[:transaction_amount]
  end
end
