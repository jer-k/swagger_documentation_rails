class PaymentsController < ApplicationController

  class LeaseCalculatorError < StandardError; end

  def calculate
    [:zip_code, :finance_type, :payment_calculations].each do |param|
      params.require(param)
    end

    calculator = params[:finance_type].upcase == 'LOAN' ? Calculators::Loan.new : (raise LeaseCalculatorError)
    @payments = calculator.build_calculate_response(params[:payment_calculations])

    render action: :payments
  rescue LeaseCalculatorError
    @error = 'Use of a calculator for Lease payments is currently unsupported'
    render 'shared/error', status: :bad_request
  end
end