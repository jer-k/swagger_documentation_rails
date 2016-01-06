json.payments_response @payments do |response|

  json.request_type   response[:request_type]
  json.response_type  response[:response_type]
  json.finance_type   response[:finance_type]
  json.group_id       response[:group_id]
  json.payment do
    json.partial! 'payment', payment: response[:payment]
  end
end