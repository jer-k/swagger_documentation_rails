module Calculators
  class Loan
    # Calculates the monthly payment amount for a group of inputs
    # @param payments [Array<Hash>]
    #
    # @return [Array<Integer>]
    def calculate_monthly_payments(payments)
      payments.map do |payment|
        calculate_monthly_payment(payment[:term], payment[:msrp], payment[:apr], payment[:dealer_reserve] || 0)
      end
    end

    # Calculates the monthly payment amount
    # @param term [Integer] the number of months financed
    # @param principle [Float]
    # @param buy_rate [Float] the interest rate the buyer received, in yearly form, aka APR
    # @param dealer_reserve [Float] the dealer markup on the buy rate, defaulted to 0%
    #
    # @return [Float]
    def calculate_monthly_payment(term, principle, buy_rate, dealer_reserve = 0.0)
      payment = if buy_rate <= 0.0 && dealer_reserve <= 0.0
                  principle / term
                else
                  rate = buy_rate + dealer_reserve
                  decimal_monthly_interest_rate = rate / 100 / 12
                  (decimal_monthly_interest_rate * principle) / (1 - (1 + decimal_monthly_interest_rate)**(-term))
                end
      payment.round(2)
    end

    # Builds a hash to serve as the response to a Payments calculate call
    # @param calculations
    #
    # @return [Array<Hash>]
    def build_calculate_response(calculations)
      request_type = "MARKET RATE"
      response_type = "MARKET_TYPE"
      finance_type = "LOAN"
      group_id = 0

      payments = calculations.map do |payment_calculation|
        if payment_calculation[:apr].blank?
          payment_service = Services::Payments.new
          payment_calculation[:apr] = payment_service.apr(payment_calculation[:credit_tier])
        end

        cost = payment_calculation[:msrp].to_f
        customer_trade = payment_calculation[:customer_trade].to_f
        down_payment = payment_calculation[:down_payment].to_f
        amount_financed = cost - customer_trade - down_payment
        credit_tier =  payment_calculation[:credit_tier]
        apr = payment_calculation[:apr].to_f
        term = payment_calculation[:term].to_i
        monthly_payment = calculate_monthly_payment(term, amount_financed, apr)
        due_at_signing = customer_trade + down_payment

        {
          amount_financed: amount_financed,
          apr: apr,
          credit_tier: credit_tier,
          due_at_signing: due_at_signing,
          monthly_payment: monthly_payment,
          sell_rate: apr,
          term: term,
        }
      end

      payments.map do |payment|
        response = {
          request_type: request_type,
          response_type: response_type,
          finance_type: finance_type,
          group_id: group_id,
          payments: [payment]
        }

        group_id += 1
        response
      end
    end
  end
end