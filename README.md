# Webirr

Official Ruby gem for WeBirr Payment Gateway APIs

This gem provides convenient access to WeBirr Payment Gateway APIs from Ruby Applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webirr'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install webirr

## Usage

The library needs to be configured with a *merchant Id* & *API key*. You can get it by contacting [webirr.com](https://webirr.com)

> You can use this library for production or test environments. you will need to set is_test_env=true for test, and false for production apps when creating objects of class WeBirr::Client

## Examples
### Creating a new Bill / Updating an existing Bill on WeBirr Servers

```rb
require 'webirr/bill'
require 'webirr/webirr_client'

# Create & Update Bill
def create_bill
    api_key = 'YOUR_API_KEY'
    merchant_id = 'YOUR_MERCHANT_ID'

    # client to use test envionment
    webirr_client = WeBirr::Client.new(api_key, true)

    bill = Webirr::Bill.new
    bill.amount = "120.45"
    bill.customer_code = "C001" # it can be email address or phone number if you dont have customer code
    bill.customer_name = "Yohannes Aregay Hailu"
    bill.time = "2022-09-06 14:20:26" # your bill time, always in this format
    bill.description = "Food delivery"
    bill.bill_reference = "ruby/2022/001" # your unique reference number
    bill.merchant_id = merchant_id

    puts "\nCreating Bill..."

    res = webirr_client.create_bill(bill)

    if (res["error"].blank?)
        # success
        payment_code = res["res"]  # returns paymentcode such as 429 723 975
        puts "\nPayment Code = #{payment_code}" # we may want to save payment code in local db.
    else
        # fail
        puts "\nerror: #{res["error"]}"
        puts "\nerrorCode: #{res["errorCode"]}" # can be used to handle specific busines error such as ERROR_INVLAID_INPUT_DUP_REF
    end

    #pp res

    # Update existing bill if it is not paid
    bill.amount = "278.00"
    bill.customer_name = 'John ruby'
    #bill.bill_reference = "WE CAN NOT CHANGE THIS"

    puts "\nUpdating Bill..."

    res = webirr_client.update_bill(bill)

    if (res["error"].blank?)
        # success
        puts "\nbill is updated succesfully" #res.res will be 'OK'  no need to check here!
    else
        # fail
        puts "\nerror: #{res["error"]}"
        puts "\nerrorCode: #{res["errorCode"]}" # can be used to handle specific busines error such as ERROR_INVLAID_INPUT
    end
end

create_bill()

```


### Getting Payment status of an existing Bill from WeBirr Servers

```rb
require 'webirr/bill'
require 'webirr/webirr_client'

# Get Payment Status of Bill
def get_webirr_payment_status
    api_key = 'YOUR_API_KEY'
    merchant_id = 'YOUR_MERCHANT_ID'

    # client to use test envionment
    webirr_client = WeBirr::Client.new(api_key, true)

    payment_code = 'PAYMENT_CODE_YOU_SAVED_AFTER_CREATING_A_NEW_BILL'  # suchas as '141 263 782'

    puts "\nGetting Payment Status..."

    res = webirr_client.get_payment_status(payment_code)

    if (res["error"].blank?) 
        # success
        if (res["res"]["status"] == 2)
          data =  res["res"]["data"]
          puts "\nbill is paid"
          puts "\nbill payment detail"
          puts "\nBank: #{data["bankID"]}"
          puts "\nBank Reference Number: #{data["paymentReference"]}"
          puts "\nAmount Paid: #{data["amount"]}"
        else
          puts "\nbill is pending payment"
        end
    else
        # fail
        puts "\nerror: #{res["error"]}"
        puts "\nerrorCode: #{res["errorCode"]}" # can be used to handle specific busines error such as ERROR_INVLAID_INPUT
    end

    #pp res
end

get_webirr_payment_status()

```

*Sample object returned from get_payment_status()*

```javascript
{
  error: null,
  res: {
    status: 2,
    data: {
      id: 111112347,
      paymentReference: '8G3303GHJN',      
      confirmed: true,
      confirmedTime: '2021-07-03 10:25:35',
      bankID: 'cbe_birr',
      time: '2021-07-03 10:25:33',
      amount: '4.60',
      wbcCode: '624 549 955'
    }
  },
  errorCode: null
}

```

### Getting Payment status of an existing Bill from WeBirr Servers

```rb
require 'webirr/bill'
require 'webirr/webirr_client'

// Get Payment Status of Webirr::Bill
def get_webirr_payment_status
    api_key = 'YOUR_API_KEY'
    merchant_id = 'YOUR_MERCHANT_ID'

    webirr_client = WeBirr::Client.new(api_key, true)

    payment_code = 'PAYMENT_CODE_YOU_SAVED_AFTER_CREATING_A_NEW_BILL'  // suchas as '141 263 782'

    puts "\nGetting Payment Status..."

    res = webirr_client.get_payment_status(payment_code)

    if (res["error"].blank?) 
        # success
        if (res["res"]["status"] == 2)
          data =  res["res"]["data"]
          puts "\nbill is paid"
          puts "\nbill payment detail"
          puts "\nBank: #{data["bankID"]}"
          puts "\nBank Reference Number: #{data["paymentReference"]}"
          puts "\nAmount Paid: #{data["amount"]}"
        else
          puts "\nbill is pending payment"
        end
    else
        # fail
        puts "\nerror: #{res["error"]}"
        puts "\nerrorCode: #{res["errorCode"]}" # can be used to handle specific busines error such as ERROR_INVLAID_INPUT
    end

    //pp res
end
get_webirr_payment_status()

```

*Sample object returned from getPaymentStatus()*

```javascript
{
  error: null,
  res: {
    status: 2,
    data: {
      id: 111112347,
      paymentReference: '8G3303GHJN',      
      confirmed: true,
      confirmedTime: '2021-07-03 10:25:35',
      bankID: 'cbe_birr',
      time: '2021-07-03 10:25:33',
      amount: '4.60',
      wbcCode: '624 549 955'
    }
  },
  errorCode: null
}

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/webirr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/webirr/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Webirr project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/webirr/blob/master/CODE_OF_CONDUCT.md).
