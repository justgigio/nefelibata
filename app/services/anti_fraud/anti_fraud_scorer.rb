module AntiFraud

  class AntiFraudScorer
    CARD_NUMBER_SCORE_WEIGHT = 1
    MERCHANT_SCORE_WEIGHT = 1

    def self.calculate(transaction)
      base_score = 100
      card_number_score = get_score_for_card_number(transaction) * CARD_NUMBER_SCORE_WEIGHT
      merchant_score = get_score_for_merchant(transaction) * MERCHANT_SCORE_WEIGHT

      base_score * (card_number_score + merchant_score) / (CARD_NUMBER_SCORE_WEIGHT + MERCHANT_SCORE_WEIGHT)
    end

    private

      def self.get_score_for_card_number(transaction)
        transactions_for_card = Transaction.where(card_number: transaction.card_number)

        total = transactions_for_card.count
        has_cbk_count = transactions_for_card.where(has_cbk: true).count

        1 - (has_cbk_count.to_f / total)
      end

      def self.get_score_for_merchant(transaction)
        transactions_merchant = Transaction.where(merchant_id: transaction.merchant_id)

        total = transactions_merchant.count
        has_cbk_count = transactions_merchant.where(has_cbk: true).count

        1 - (has_cbk_count.to_f / total)
      end

  end
end
