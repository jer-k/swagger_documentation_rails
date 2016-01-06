class PaymentsController < ApplicationController

  class LeaseCalculatorError < StandardError; end

  def calculate
    [:zip_code, :finance_type, :payment_calculations].each do |param|
      params.require(param)
    end

    validate_calculate_params(params)

    calculator = params[:finance_type].capitalize == 'Loan' ? Calculators::Loan.new : nil
    if calculator
      @payments = calculator.build_calculate_response(params[:payment_calculations])
      render action: :payments
    else
      @error = 'Use of a calculator for Lease payments is currently unsupported'
      render 'shared/error', status: :not_implemented
    end
  end

  private

  VALID_TERMS = [12, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84]

  def validate_calculate_params(calculate_params)
    calculate_params[:payment_calculations].each do |calculation|
      raise ArgumentError, "#{calculation[:term]} is not a valid term" unless VALID_TERMS.include?(calculation[:term])
      raise ArgumentError, 'MSRP is not > 0' if calculation[:msrp] <= 0
      if calculation[:msrp] - calculation[:customer_trade] - calculation[:down_payment] <= 0
        raise ArgumentError, 'Total cost (MSRP - Customer Trade - Down Payment) is not > 0'
      end
    end
  end
end