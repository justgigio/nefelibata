desc "Print some analysis of current Transactions"

namespace :analyze do
  BASE_PATH = Rails.root.join('tmp')

  task by_user: [:environment] do

    transactions_by_user = {}

    Transaction.order(:transaction_date).all.each do |t|
      transactions_by_user[t.user_id] ||= []
      transactions_by_user[t.user_id].push(t)
    end

    transactions_by_user = transactions_by_user.sort_by { |k, v| -v.size }

    file_name = BASE_PATH.join('analyze_by_user.txt')

    File.open(file_name, "w") do |file|
      transactions_by_user.each do |user_id, t|
        file.puts("+#{'-' * 108}+")
        file.puts("| User ID: ##{user_id.to_s.ljust(96, ' ')} |")
        file.puts("+#{'-' * 108}+")
        file.write("| ")
        line = []
        line.push("id".ljust(10, ' '))
        line.push("merc_id".ljust(7, ' '))
        line.push("card_number".ljust(19, ' '))
        line.push("date".ljust(25, ' '))
        line.push("amount".ljust(10, ' '))
        line.push("device_id".ljust(10, ' '))
        line.push("has_cbk".ljust(7, ' '))
        file.write( line * ' | ')
        file.puts(" |")
        file.puts("+#{'-' * 108}+")
        sorted_t = t.sort_by { |o| "#{o.has_cbk}-#{o.transaction_date}" }
        sorted_t.each do |to|
          file.write("| ")
          line = []
          line.push(to.transaction_id.to_s.ljust(10, ' '))
          line.push(to.merchant_id.to_s.ljust(7, ' '))
          line.push(to.card_number.ljust(19, ' '))
          line.push(to.transaction_date.strftime("%Y-%m-%d %H:%M:%S.%L").ljust(25, ' '))
          line.push(("%0.2f" % [to.transaction_amount / 100.0]).rjust(10, ' '))
          line.push(to.device_id.to_s.ljust(10, ' '))
          has_cbk = to.has_cbk ? "TRUE" : "FALSE"
          line.push(has_cbk.ljust(7, ' '))
          file.write( line * ' | ')
          file.puts(" |")
        end
        file.puts("+#{'-' * 108}+")
      end
    end

    puts("File successful written at: #{file_name}")
  end

  task by_merchant: [:environment] do

    transactions_by_merchant = {}

    Transaction.order(:transaction_date).all.each do |t|
      transactions_by_merchant[t.merchant_id] ||= []
      transactions_by_merchant[t.merchant_id].push(t)
    end

    transactions_by_merchant = transactions_by_merchant.sort_by { |k, v| -v.size }

    file_name = BASE_PATH.join('analyze_by_merchant.txt')

    File.open(file_name, "w") do |file|
      transactions_by_merchant.each do |merchant_id, t|
        file.puts("+#{'-' * 108}+")
        file.puts("| Merchant ID: ##{merchant_id.to_s.ljust(92, ' ')} |")
        file.puts("+#{'-' * 108}+")
        file.write("| ")
        line = []
        line.push("id".ljust(10, ' '))
        line.push("user_id".ljust(7, ' '))
        line.push("card_number".ljust(19, ' '))
        line.push("date".ljust(25, ' '))
        line.push("amount".ljust(10, ' '))
        line.push("device_id".ljust(10, ' '))
        line.push("has_cbk".ljust(7, ' '))
        file.write( line * ' | ')
        file.puts(" |")
        file.puts("+#{'-' * 108}+")
        sorted_t = t.sort_by { |o| "#{o.has_cbk}-#{o.transaction_date}" }
        sorted_t.each do |to|
          file.write("| ")
          line = []
          line.push(to.transaction_id.to_s.ljust(10, ' '))
          line.push(to.user_id.to_s.ljust(7, ' '))
          line.push(to.card_number.ljust(19, ' '))
          line.push(to.transaction_date.strftime("%Y-%m-%d %H:%M:%S.%L").ljust(25, ' '))
          line.push(("%0.2f" % [to.transaction_amount / 100.0]).rjust(10, ' '))
          line.push(to.device_id.to_s.ljust(10, ' '))
          has_cbk = to.has_cbk ? "TRUE" : "FALSE"
          line.push(has_cbk.ljust(7, ' '))
          file.write( line * ' | ')
          file.puts(" |")
        end
        file.puts("+#{'-' * 108}+")
      end
    end

    puts("File successful written at: #{file_name}")
  end

  task by_card_number: [:environment] do

    transactions_by_card_number = {}

    Transaction.order(:transaction_date).all.each do |t|
      transactions_by_card_number[t.card_number] ||= []
      transactions_by_card_number[t.card_number].push(t)
    end

    transactions_by_card_number = transactions_by_card_number.sort_by { |k, v| -v.size }

    file_name = BASE_PATH.join('analyze_by_card_number.txt')

    File.open(file_name, "w") do |file|
      transactions_by_card_number.each do |card_number, t|
        file.puts("+#{'-' * 108}+")
        file.puts("| Card Number: #{card_number.to_s.ljust(93, ' ')} |")
        file.puts("+#{'-' * 108}+")
        file.write("| ")
        line = []
        line.push("id".ljust(10, ' '))
        line.push("merchant_id".ljust(13, ' '))
        line.push("user_id".ljust(13, ' '))
        line.push("date".ljust(25, ' '))
        line.push("amount".ljust(10, ' '))
        line.push("device_id".ljust(10, ' '))
        line.push("has_cbk".ljust(7, ' '))
        file.write( line * ' | ')
        file.puts(" |")
        file.puts("+#{'-' * 108}+")
        sorted_t = t.sort_by { |o| "#{o.has_cbk}-#{o.transaction_date}" }
        sorted_t.each do |to|
          file.write("| ")
          line = []
          line.push(to.transaction_id.to_s.ljust(10, ' '))
          line.push(to.merchant_id.to_s.ljust(13, ' '))
          line.push(to.user_id.to_s.ljust(13, ' '))
          line.push(to.transaction_date.strftime("%Y-%m-%d %H:%M:%S.%L").ljust(25, ' '))
          line.push(("%0.2f" % [to.transaction_amount / 100.0]).rjust(10, ' '))
          line.push(to.device_id.to_s.ljust(10, ' '))
          has_cbk = to.has_cbk ? "TRUE" : "FALSE"
          line.push(has_cbk.ljust(7, ' '))
          file.write( line * ' | ')
          file.puts(" |")
        end
        file.puts("+#{'-' * 108}+")
      end
    end

    puts("File successful written at: #{file_name}")
  end

  task by_device: [:environment] do

    transactions_by_device = {}

    Transaction.order(:transaction_date).all.each do |t|
      transactions_by_device[t.device_id] ||= []
      transactions_by_device[t.device_id].push(t)
    end

    transactions_by_device = transactions_by_device.sort_by { |k, v| -v.size }

    file_name = BASE_PATH.join('analyze_by_device.txt')

    File.open(file_name, "w") do |file|
      transactions_by_device.each do |device_id, t|
        file.puts("+#{'-' * 108}+")
        file.puts("| Device ID: ##{device_id.to_s.ljust(94, ' ')} |")
        file.puts("+#{'-' * 108}+")
        file.write("| ")
        line = []
        line.push("id".ljust(10, ' '))
        line.push("merc_id".ljust(10, ' '))
        line.push("user_id".ljust(7, ' '))
        line.push("card_number".ljust(19, ' '))
        line.push("date".ljust(25, ' '))
        line.push("amount".ljust(10, ' '))
        line.push("has_cbk".ljust(7, ' '))
        file.write( line * ' | ')
        file.puts(" |")
        file.puts("+#{'-' * 108}+")
        sorted_t = t.sort_by { |o| "#{o.has_cbk}-#{o.transaction_date}" }
        sorted_t.each do |to|
          file.write("| ")
          line = []
          line.push(to.transaction_id.to_s.ljust(10, ' '))
          line.push(to.merchant_id.to_s.ljust(10, ' '))
          line.push(to.user_id.to_s.ljust(7, ' '))
          line.push(to.card_number.ljust(19, ' '))
          line.push(to.transaction_date.strftime("%Y-%m-%d %H:%M:%S.%L").ljust(25, ' '))
          line.push(("%0.2f" % [to.transaction_amount / 100.0]).rjust(10, ' '))
          has_cbk = to.has_cbk ? "TRUE" : "FALSE"
          line.push(has_cbk.ljust(7, ' '))
          file.write( line * ' | ')
          file.puts(" |")
        end
        file.puts("+#{'-' * 108}+")
      end
    end

    puts("File successful written at: #{file_name}")
  end

  task scorer_v1: [:environment] do
    transactions = []
    Transaction.order(:transaction_date).each do |transaction|
      transactions.push(transaction)
    end

    anti_fraud_min_score_to_aprove = AntiFraud::AntiFraudService::MIN_SCORE_TO_APROVE

    score_sum = 0
    score_count = 0

    score_hit = 0
    score_miss = 0

    score_false_positive_count = 0
    score_false_positive_diff = 0

    score_false_negative_count = 0
    score_false_negative_diff = 0


    transactions.each do |transaction|
      # Force scope to check only transactions before
      class Transaction < ApplicationRecord
        def self.default_scope
          where("transaction_date < ?", transaction.transaction_date)
        end
      end

      score = AntiFraud::AntiFraudScorer.calculate(transaction)

      score_sum += score
      score_count += 1

      if score >= anti_fraud_min_score_to_aprove
        if transaction.has_cbk == false
          score_hit += 1
        else
          score_miss += 1
          score_false_negative_count += 1
          score_false_negative_diff += (score - anti_fraud_min_score_to_aprove)
        end
      else
        if transaction.has_cbk
          score_hit += 1
        else
          score_miss += 1
          score_false_positive_count += 1
          score_false_positive_diff += (anti_fraud_min_score_to_aprove - score)
        end
      end

      # clear forced scope
      class Transaction < ApplicationRecord
        def self.default_scope; end
      end
    end

    puts("Total: #{score_count}")
    puts("Hits: #{score_hit} (#{score_hit * 100.0 / score_count}%)")
    puts("Misses: #{score_miss} (#{score_miss * 100.0 / score_count}%)")

    puts("False positives: #{score_false_positive_count} (#{score_false_positive_count * 100.0 / score_miss} %)")
    puts("False positive AVG deviation: #{score_false_positive_diff.to_f / score_false_positive_count}")

    puts("False negatives: #{score_false_negative_count} (#{score_false_negative_count * 100.0 / score_miss}%)")
    puts("False negative AVG deviation: #{score_false_negative_diff.to_f / score_false_negative_count}")

  end
end
