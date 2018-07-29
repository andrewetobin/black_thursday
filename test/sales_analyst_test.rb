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

  def test_check_invoice_paid
    assert_equal true, @sales_analyst.invoice_paid_in_full?(1358)
    assert_equal true, @sales_analyst.invoice_paid_in_full?(3752)
    assert_equal false, @sales_analyst.invoice_paid_in_full?(1114)
    assert_equal false, @sales_analyst.invoice_paid_in_full?(4221)
  end

  def test_it_can_return_the_amount_for_any_invoice
    assert_equal 24978.08, @sales_analyst.invoice_total(34)
  end

  def test_average_invoices_per_merchant_standard_deviation
    skip
    assert_equal 3.29, @sales_analyst.average_invoices_per_merchant_standard_deviation
    assert_instance_of Float, @sales_analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_average_invoices_per_merchant_standard_deviation
    skip
    assert_equal 10.49, @sales_analyst.average_invoices_per_merchant
    assert_instance_of Float, @sales_analyst.average_invoices_per_merchant
  end

  def test_top_merchants_by_invoice_count
    skip
    assert_equal 12, @sales_analyst.top_merchants_by_invoice_count.count
    assert_instance_of Merchant, @sales_analyst.top_merchants_by_invoice_count[0]
  end

  def test_bottom_merchants_by_invoice_count
    skip
    assert_equal 4, @sales_analyst.bottom_merchants_by_invoice_count.count
    assert_instance_of Merchant, @sales_analyst.bottom_merchants_by_invoice_count[0]
  end

  def test_top_days_by_invoice_count
    skip
    assert_equal 1, @sales_analyst.top_days_by_invoice_count.count
    assert_equal "Wednesday", @sales_analyst.top_days_by_invoice_count.join
    assert_instance_of String, @sales_analyst.top_days_by_invoice_count.join
  end

  def test_invoice_status
    skip
    assert_equal 29.55, @sales_analyst.invoice_status(:pending)
    assert_equal 56.95, @sales_analyst.invoice_status(:shipped)
    assert_equal 13.5, @sales_analyst.invoice_status(:returned)
  end

  def test_total_revenue_by_date
    date = Time.parse("2009-02-07")
    assert_instance_of BigDecimal, @sales_analyst.total_revenue_by_date(date)
    assert_equal 21067.77, @sales_analyst.total_revenue_by_date(date).to_f
  end

  




end
