require "test_helper"

class AntiFraudServiceTest < ActiveSupport::TestCase
  self.use_transactional_tests = true

  def test_reject_transaction_if_user_is_trying_too_many_transactions_in_a_row

    time_window = AntiFraud::AntiFraudService::TOO_MANY_TRANSACTIONS_TIME_WINDOW
    max_transactions = AntiFraud::AntiFraudService::TOO_MANY_TRANSACTIONS_COUNT

    base_date = DateTime.now - time_window
    layout = {
      :transaction_id => 1,
      :merchant_id => 1,
      :user_id => 1,
      :card_number => "123456******1234",
      :transaction_date => base_date,
      :transaction_amount => 32734,
      :device_id => 1
    }
    10.times do
      Transaction.create(layout)
      layout[:transaction_id] += 1
      layout[:transaction_date] += time_window / (max_transactions + 1)
    end

    transaction = Transaction.new(layout)

    recommendation = AntiFraud::AntiFraudService.analyze(transaction)

    assert_equal AntiFraud::Recommendation::REJECT, recommendation
  end

  def test_reject_transactions_above_a_certain_amount_in_a_given_period
    start_hour = AntiFraud::AntiFraudService::LIMIT_AMOUNT_PERIOD_START
    end_hour = AntiFraud::AntiFraudService::LIMIT_AMOUNT_PERIOD_END
    limit_amount = AntiFraud::AntiFraudService::LIMIT_AMOUNT_MAX_VALUE

    base_date = DateTime.now
    delta_hour = start_hour - base_date.hour.hours

    layout = {
      :transaction_id => 1,
      :merchant_id => 1,
      :user_id => 1,
      :card_number => "123456******1234",
      :transaction_date => base_date + delta_hour - 1.hour,
      :transaction_amount => limit_amount + 1,
      :device_id => 1
    }

    bad_amount_good_time = Transaction.new(layout)

    recommendation = AntiFraud::AntiFraudService.analyze(bad_amount_good_time)

    assert_equal AntiFraud::Recommendation::APPROVE, recommendation

    layout[:transaction_date] += 2.hours
    layout[:transaction_amount] = limit_amount - 1
    good_amount_bad_time = Transaction.new(layout)

    recommendation = AntiFraud::AntiFraudService.analyze(good_amount_bad_time)

    assert_equal AntiFraud::Recommendation::APPROVE, recommendation

    layout[:transaction_amount] = limit_amount + 1
    bad_amount_bad_time = Transaction.new(layout)

    recommendation = AntiFraud::AntiFraudService.analyze(bad_amount_bad_time)

    assert_equal AntiFraud::Recommendation::REJECT, recommendation
  end

  def test_reject_transaction_if_a_user_had_a_chargeback_before
    base_date = DateTime.now - 2.days
    layout = {
      :transaction_id => 1,
      :merchant_id => 1,
      :user_id => 1,
      :card_number => "123456******1234",
      :transaction_date => base_date,
      :transaction_amount => 2,
      :device_id => 1
    }

    Transaction.create(layout)

    layout[:transaction_id] += 1
    layout[:transaction_date] = DateTime.now
    new_transaction = Transaction.new(layout)

    recommendation = AntiFraud::AntiFraudService.analyze(new_transaction)

    assert_equal AntiFraud::Recommendation::APPROVE, recommendation

    layout[:has_cbk] = true
    layout[:transaction_id] += 1
    layout[:transaction_date] = DateTime.now - 1.days

    Transaction.create(layout)

    recommendation = AntiFraud::AntiFraudService.analyze(new_transaction)

    assert_equal AntiFraud::Recommendation::REJECT, recommendation
  end
end
