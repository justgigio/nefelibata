module V1
  class AntiFraudController < ApplicationController
    include SecureWithToken

    before_action :authenticate

    def analyze
      transaction = Transaction.find_by(transaction_id: transaction_params[:transaction_id])

      if transaction.nil?
        transaction = Transaction.new(transaction_params)

        if transaction.valid?
          transaction.save
        else
          return render json: transaction.errors, status: :unprocessable_entity
        end
      end

      unless transaction.is_authentic_duplication?(transaction_params)
        error_json = {"transaction_id": ["Duplicate transaction_id with different params"]}
        return render json: error_json, status: :unprocessable_entity
      end

      if transaction.recommendation.nil?
        transaction.recommendation = AntiFraud::AntiFraudService.analyze(transaction)
        transaction.save
      end

      json_response = {
        "transaction_id" => transaction.transaction_id,
        "recommendation" => transaction.recommendation
      }

      render json: json_response
    end

    private

      def transaction_params
        params.permit(
          :transaction_id,
          :merchant_id,
          :user_id,
          :card_number,
          :transaction_date,
          :transaction_amount,
          :device_id
        )
      end
  end
end
