# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'

Transaction.delete_all
normalized_transactions = []
has_error = false

csv = CSV.read(Rails.root.join('db', 'seed_transactions.csv'), :headers => true)

csv.each do |row|
  transaction = Transaction.new
  transaction.transaction_id = row['transaction_id'].to_i
  transaction.merchant_id = row['merchant_id'].to_i
  transaction.user_id = row['user_id'].to_i
  transaction.card_number = row['card_number']
  transaction.transaction_date = row['transaction_date']
  transaction.transaction_amount = row['transaction_amount'].gsub(/[.,]/, '').to_i
  transaction.device_id = row['device_id'].nil? ? nil : row['device_id'].to_i
  transaction.has_cbk = (row['has_cbk'] == 'TRUE')

  if transaction.valid?
    normalized_transactions.append(transaction.attributes.reject { |k, v| k == "id" })
  else
    has_error = true
    transaction.errors.each do |error|
      puts "[#{transaction.transaction_id}] #{error.message}"
    end
  end
end

unless has_error
  Transaction.insert_all(normalized_transactions)
end
