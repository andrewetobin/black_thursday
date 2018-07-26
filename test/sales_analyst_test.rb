require './test/test_helper.rb'
require './lib/sales_analyst.rb'

class SalesAnalystTest < Minitest::Test

  def setup
    sales_engine = SalesEngine.from_csv(
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv',
      customers: './data/customers.csv',
      invoice_items: './data/invoice_items.csv',
      transactions: './data/transactions.csv'
    )
    @sales_analyst = SalesAnalyst.new(sales_engine)
  end


  def test_it_exists
    skip
    assert_instance_of SalesAnalyst, @sales_analyst
  end


  def test_average_items_per_merchant
    skip
    assert_equal 2.88, @sales_analyst.average_items_per_merchant
  end


  def test_average_items_per_merchant_standard_deviation
    skip
    assert_equal 3.26, @sales_analyst.average_items_per_merchant_standard_deviation
  end


  def test_merchants_with_high_item_count
    skip
    assert_equal 52, @sales_analyst.merchants_with_high_item_count.count
    assert_instance_of Merchant, @sales_analyst.merchants_with_high_item_count.first
  end


  def test_it_can_find_average_item_price_per_merchant
    skip
    assert_equal 16.66, @sales_analyst.average_item_price_for_merchant(12334105)
  end


  def test_it_can_find_average_average_item_price_per_merchant
    skip
    assert_equal 350.29, @sales_analyst.average_average_price_per_merchant
  end


  def test_it_can_find_the_price_standard_deviation
    skip
    assert_equal 2900.99, @sales_analyst.item_price_standard_deviation
  end


  def test_it_can_find_all_golden_items
    skip
    assert_equal 5, @sales_analyst.golden_items.length
    assert_equal Item, @sales_analyst.golden_items.first.class
  end


  def test_average_invoices_per_merchant
    skip
    assert_equal 10.49, @sales_analyst.average_invoices_per_merchant
  end


  def test_average_invoices_per_merchant_standard_deviation
    skip
    assert_equal 3.29, @sales_analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_top_merchants_by_invoice_count
    assert_equal 12, @sales_analyst.top_merchants_by_invoice_count.count
    assert_instance_of Merchant, @sales_analyst.top_merchants_by_invoice_count[0]
  end



end
