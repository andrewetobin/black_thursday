require './test/test_helper'
require './lib/invoice'

class InvoiceTest < Minitest::Test
  def test_it_exists
    inv = Invoice.new({
                      id:           6,
                      customer_id:  7,
                      merchant_id:  8,
                      status:       "pending",
                      created_at:   Time.now,
                      updated_at:   Time.now
                    })
    assert_instance_of Invoice, inv
  end

  def test_it_has_attributes
    inv = Invoice.new({
                      id:           6,
                      customer_id:  7,
                      merchant_id:  8,
                      status:       "pending",
                      created_at:   '2001-09-17 15:28:43 UTC',
                      updated_at:   '2016-01-11 11:51:36 UTC'
                    })
    assert_equal 6, inv.id
    assert_equal 7, inv.customer_id
    assert_equal 8, inv.merchant_id
    assert_equal "pending", inv.status
    assert_equal Time.parse('2001-09-17 15:28:43 UTC'), inv.created_at
    assert_equal Time.parse('2016-01-11 11:51:36 UTC'), inv.updated_at
  end
end
