# frozen_string_literal: true

require "json"

module Webirr
  class Bill
    attr_accessor :customer_code,
                  :customer_name,
                  :amount,
                  :description,
                  :bill_reference,
                  :merchant_id,
                  :time

    def as_json(_options = {})
      {
        customerCode: @customer_code,
        customerName: @customer_name,
        amount: @amount,
        description: @description,
        billReference: @bill_reference,
        merchantID: @merchant_id,
        time: @time
      }
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end
  end
end