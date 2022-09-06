require "faraday"

class WebirrClient
  def initialize(api_key, is_test_env)
    @api_key = api_key
    @client =
      Faraday.new(
        url:
          "#{is_test_env ? "https://api.webirr.com/" : "https://api.webirr.com:8080/"}",
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
      @client.post("einvoice/api/postbill") { |req| req.body = bill.to_json }
    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "http error #{response.status} #{response.reason_phrase}" }
    end
  end

  def update_bill(bill)
    response =
      @client.put("einvoice/api/postbill") { |req| req.body = bill.to_json }
    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "http error #{response.status} #{response.reason_phrase}" }
    end
  end

  def delete_bill(payment_code)
    response = @client.put("einvoice/api/deletebill?wbc_code=#{payment_code}")
    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "http error #{response.status} #{response.reason_phrase}" }
    end
  end

  def get_payment_status(payment_code)
    response =
      @client.get("einvoice/api/getPaymentStatus?wbc_code=#{payment_code}")
    if response.success?
      JSON.parse(response.body)
    else
      { "error" => "http error #{response.status} #{response.reason_phrase}" }
    end
  end
end
