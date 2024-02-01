module AntiFraud
  module Recommendation
    APPROVE = "approve"
    REJECT = "deny"
  end

  class AntiFraudService
    # some configuration that would come from a DB table
    TOO_MANY_TRANSACTIONS_COUNT = 10
    TOO_MANY_TRANSACTIONS_TIME_WINDOW = 1.minute
    LIMIT_AMOUNT_PERIOD_START = 23.hours # 11 PM
    LIMIT_AMOUNT_PERIOD_END = 6.hours # 6 AM
    LIMIT_AMOUNT_MAX_VALUE = 30000 # 300,00
    MIN_SCORE_TO_APROVE = 50.0

    def self.analyze(transaction)
      return Recommendation::REJECT if has_too_many_transactions_in_a_row?(transaction)
      return Recommendation::REJECT if amount_above_permited_for_period?(transaction)
      return Recommendation::REJECT if user_had_chargeback_before?(transaction)
      return Recommendation::REJECT if AntiFraudScorer.calculate(transaction) < MIN_SCORE_TO_APROVE
      Recommendation::APPROVE
    end

    private

      def self.has_too_many_transactions_in_a_row?(transaction)
        end_date = transaction.transaction_date
        start_date = end_date - TOO_MANY_TRANSACTIONS_TIME_WINDOW

        transactions_in_time_window = Transaction.where(transaction_date: start_date..end_date).count

        transactions_in_time_window >= TOO_MANY_TRANSACTIONS_COUNT
      end

      def self.amount_above_permited_for_period?(transaction)
        if LIMIT_AMOUNT_PERIOD_END > LIMIT_AMOUNT_PERIOD_START
          periods = [(LIMIT_AMOUNT_PERIOD_START..LIMIT_AMOUNT_PERIOD_END)]
        else
          periods = [(LIMIT_AMOUNT_PERIOD_START..24.hours), (0.hours..LIMIT_AMOUNT_PERIOD_END)]
        end

        between_period = false
        periods.each do |period|
          between_period = true if transaction.transaction_date.hour.hours.between?(period.first, period.last)
        end

        between_period && transaction.transaction_amount > LIMIT_AMOUNT_MAX_VALUE
      end

      def self.user_had_chargeback_before?(transaction)
        Transaction.where(user_id: transaction.user_id, has_cbk: true).exists?
      end
    end
end
