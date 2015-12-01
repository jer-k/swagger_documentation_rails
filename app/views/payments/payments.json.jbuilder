json.payments_groups @payments do |payment|

  json.request_type   payment[:request_type]
  json.response_type  payment[:response_type]
  json.finance_type   payment[:finance_type]
  json.group_id       payment[:group_id]
  json.payments payment[:payments] do |p|
    json.partial! 'payment', payment: p
  end
end