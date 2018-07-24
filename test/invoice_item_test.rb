require './test/test_helper'
require './lib/invoice_item'

class InvoiceItemTest < Minitest::Test

  def setup
   @invoice_item = InvoiceItem.new(
     id: 6,
     item_id: 7,
     invoice_id: 8,
     quantity: 1,
     unit_price: BigDecimal(1099, 4),
     created_at: '2016-01-11 11:51:36 UTC',
     updated_at: '2001-09-17 15:28:43 UTC'
   )
 end

  def test_it_exists
    assert_instance_of InvoiceItem, @invoice_item
  end

  def test_it_has_attributes
    assert_equal 6, @invoice_item.id
    assert_equal 7, @invoice_item.item_id
    assert_equal 8, @invoice_item.invoice_id
    assert_equal 1, @invoice_item.quantity
    assert_equal 10.99, @invoice_item.unit_price
    assert_equal Time.parse('2016-01-11 11:51:36 UTC'), @invoice_item.created_at
    assert_equal Time.parse('2001-09-17 15:28:43 UTC'), @invoice_item.updated_at
  end

  def test_change_unit_price_to_float
    refute_equal @invoice_item.unit_price.inspect, '10.99'
    assert_equal @invoice_item.unit_price_to_dollars.inspect, 10.99.inspect
  end










end
