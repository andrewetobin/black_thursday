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
    assert_instance_of SalesAnalyst, @sales_analyst
  end


  def test_average_items_per_merchant
    assert_equal 2.88, @sales_analyst.average_items_per_merchant
  end


  def test_average_items_per_merchant_standard_deviation
    assert_equal 3.26, @sales_analyst.average_items_per_merchant_standard_deviation
  end


  def test_merchants_with_high_item_count
    assert_equal 52, @sales_analyst.merchants_with_high_item_count.count
    assert_instance_of Merchant, @sales_analyst.merchants_with_high_item_count.first
  end


  def test_it_can_find_average_item_price_per_merchant
    assert_equal 16.66, @sales_analyst.average_item_price_for_merchant(12334105)
  end


  def test_it_can_find_average_average_item_price_per_merchant
    assert_equal 350.29, @sales_analyst.average_average_price_per_merchant
  end


  def test_it_can_find_the_price_standard_deviation
    assert_equal 2900.99, @sales_analyst.item_price_standard_deviation
  end


  def test_it_can_find_all_golden_items
    assert_equal 5, @sales_analyst.golden_items.length
    assert_equal Item, @sales_analyst.golden_items.first.class
  end


  def test_average_invoices_per_merchant
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
    assert_equal 3.29, @sales_analyst.average_invoices_per_merchant_standard_deviation
    assert_instance_of Float, @sales_analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_average_invoices_per_merchant_standard_deviation
    assert_equal 10.49, @sales_analyst.average_invoices_per_merchant
    assert_instance_of Float, @sales_analyst.average_invoices_per_merchant
  end

  def test_top_merchants_by_invoice_count
    assert_equal 12, @sales_analyst.top_merchants_by_invoice_count.count
    assert_instance_of Merchant, @sales_analyst.top_merchants_by_invoice_count[0]
  end

  def test_bottom_merchants_by_invoice_count
    assert_equal 4, @sales_analyst.bottom_merchants_by_invoice_count.count
    assert_instance_of Merchant, @sales_analyst.bottom_merchants_by_invoice_count[0]
  end

  def test_top_days_by_invoice_count
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

  def test_it_can_find_merchants_with_pending_invoices
    assert_equal 467, @sales_analyst.merchants_with_pending_invoices.length
    assert_equal Merchant, @sales_analyst.merchants_with_pending_invoices.first.class
  end

  def test_it_can_find_merchants_with_only_one_item
    assert_equal Array, @sales_analyst.merchants_with_only_one_item.class
    assert_equal 243, @sales_analyst.merchants_with_only_one_item.length
    assert_equal Merchant, @sales_analyst.merchants_with_only_one_item.first.class
  end

  def test_it_can_find_merchants_with_one_invoice_in_given_month
    assert_equal 21, @sales_analyst.merchants_with_only_one_item_registered_in_month('March').length
    assert_equal 18, @sales_analyst.merchants_with_only_one_item_registered_in_month('July').length
    assert_equal Merchant, @sales_analyst.merchants_with_only_one_item_registered_in_month('March').first.class
    assert_equal Merchant, @sales_analyst.merchants_with_only_one_item_registered_in_month('March').last.class
  end

  def test_it_can_find_most_sold_item_for_merchant
    assert_equal 263411587, @sales_analyst.most_sold_item_for_merchant(12336111).first.id
    assert_equal "Painting &quot;Purple peonies&quot;", @sales_analyst.most_sold_item_for_merchant(12336111).first.name
    assert_instance_of Item, @sales_analyst.most_sold_item_for_merchant(12336111).first
    assert_equal 263411851, @sales_analyst.most_sold_item_for_merchant(12335853).first.id
    assert_equal 4, @sales_analyst.most_sold_item_for_merchant(12337105).length
  end
  
  def test_total_revenue_by_date
    skip
    date = Time.parse("2009-02-07")
    assert_instance_of BigDecimal, @sales_analyst.total_revenue_by_date(date)
    assert_equal 21067.77, @sales_analyst.total_revenue_by_date(date).to_f
  end

  def test_top_revenue_earners
    assert_equal 10, @sales_analyst.top_revenue_earners(10).count
    assert_equal 20, @sales_analyst.top_revenue_earners.count
    assert_instance_of Merchant, @sales_analyst.top_revenue_earners(10)[0]
    assert_equal 12334634, @sales_analyst.top_revenue_earners(10)[0].id
  end

  def test_revenue_by_merchant
    skip
    assert_instance_of BigDecimal, @sales_analyst.revenue_by_merchant(12334105)
    assert_equal 106170.51, @sales_analyst.revenue_by_merchant(12334105)
  end

  def test_find_successful_items_per_merchant_id
    assert_equal 11, @sales_analyst.successful_items_per_merchant_id(12336111).count
    assert_equal InvoiceItem, @sales_analyst.successful_items_per_merchant_id(12336111).first.class
  end

  def test_with_array_of_invoice_items_group_by_id_with_total_price
    array = @sales_analyst.successful_items_per_merchant_id(12335853)
    assert_equal 9, @sales_analyst.invoice_items_with_total_price(array).keys.count
    assert_equal Hash, @sales_analyst.invoice_items_with_total_price(array).class
    assert_equal BigDecimal, @sales_analyst.invoice_items_with_total_price(array).values.first.class
  end

  def test_it_can_find_high_item_from_hash
    hash = { 834716263 => 20, 8371625023 => 40 }
    item = @sales_analyst.sales_engine.items.find_by_id(8371625023)
    assert_equal item, @sales_analyst.high_item_from_ids_with_values(hash).first
  end

  def test_it_can_find_best_item_for_merchant
    assert_equal 263417715, @sales_analyst.best_item_for_merchant(12336749).id
    assert_equal 263526714, @sales_analyst.best_item_for_merchant(12336069).id
  end
end
