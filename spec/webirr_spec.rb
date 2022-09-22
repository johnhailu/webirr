# frozen_string_literal: true

RSpec.describe Webirr do
  it "has a version number" do
    expect(Webirr::VERSION).not_to be nil
  end

  it "#create_bill should get error from web service on invalid api key on test environment" do
    client = Webirr::Client.new("x", true)
    res = client.create_bill(sample_bill)
    expect(res["error"]).not_to be nil
  end

  it "#create_bill should get error from web service on invalid api key on production environment" do
    client = Webirr::Client.new("x", false)
    res = client.create_bill(sample_bill)
    expect(res["error"]).not_to be nil
  end

  it "#update_bill should get error from web service on invalid api key" do
    client = Webirr::Client.new("x", true)
    res = client.update_bill(sample_bill)
    expect(res["error"]).not_to be nil
  end

  it "#delete_bill should get error from web service on invalid api key" do
    client = Webirr::Client.new("x", true)
    res = client.delete_bill("abcd")
    expect(res["error"]).not_to be nil
  end

  it "#get_payment_status should get error from web service on invalid api key" do
    client = Webirr::Client.new("x", true)
    res = client.get_payment_status("abcd")
    expect(res["error"]).not_to be nil
  end

  def sample_bill
    bill = Webirr::Bill.new
    bill.amount = "120.45"
    bill.customer_code = "C001"
    bill.customer_name = "Yohannes Aregay Hailu"
    bill.time = "2022-09-06 14:20:26"
    bill.description = "Food delivery"
    bill.bill_reference = "ruby/2022/001"
    bill.merchant_id = "ruby"
    bill
  end
end
