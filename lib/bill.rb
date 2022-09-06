require "json"

class Bill
  attr_accessor :customer_code,
                :customer_name,
                :amount,
                :description,
                :bill_reference,
                :merchant_id,
                :time

  def as_json(options = {})
    {
      customer_code: @customer_code,
      customer_name: @customer_name,
      amount: @amount,
      description: @description,
      bill_reference: @bill_reference,
      merchant_id: @merchant_id,
      time: @time
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end
end
