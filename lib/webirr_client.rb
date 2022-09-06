# frozen_string_literal: true

require "faraday"

class WebirrClient
  def initialize(api_key, is_test_env)
    @api_key = api_key
    @client =
      Faraday.new(
        url:
          (is_test_env ? "https://api.webirr.com/einvoice/api/" : "https://api.webirr.com:8080/einvoice/api/").to_s,
        params: {
          "api_key" => @api_key
        },
        headers: {
          "Content-Type" => "application/json"
        }
      )
  end

  def create_bill(bill)
    response =
      @client.post("postbill") { |req| req.body = bill.to_json }
    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "http error #{response.status} #{response.reason_phrase}" }
    end
  end

  def update_bill(bill)
    response =
      @client.put("postbill") { |req| req.body = bill.to_json }
    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "http error #{response.status} #{response.reason_phrase}" }
    end
  end

  def delete_bill(payment_code)
    response = @client.put("deletebill?wbc_code=#{payment_code}")
    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "http error #{response.status} #{response.reason_phrase}" }
    end
  end

  def get_payment_status(payment_code)
    response =
      @client.get("getPaymentStatus?wbc_code=#{payment_code}")
    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "http error #{response.status} #{response.reason_phrase}" }
    end
  end
end
