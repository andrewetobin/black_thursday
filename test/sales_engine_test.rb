require './test/test_helper.rb'
require './lib/sales_engine.rb'

class SalesEngineTest < Minitest::Test
  def test_it_exists
    sales_engine = SalesEngine.from_csv('content')
    assert_instance_of SalesEngine, sales_engine
  end

  def test_it_has_from_csv
    sales_engine = SalesEngine.from_csv(
      items: './data/items.csv',
      merchants: './data/merchants.csv'
    )
    assert_equal ({
      items: './data/items.csv',
      merchants: './data/merchants.csv'
    }), sales_engine.info
  end

  def test_merchants_creates_array_of_merchants
    sales_engine = SalesEngine.from_csv(
      items: './data/items.csv',
      merchants: './data/merchants.csv'
    )
    assert_equal 475, sales_engine.merchants.repo.count
  end

  def test_items_creates_repository_of_items
    sales_engine = SalesEngine.from_csv(
      items: './data/items.csv',
      merchants: './data/merchants.csv'
    )
    assert_instance_of ItemRepository, sales_engine.items
  end

  def test_it_can_create_an_analyst
    sales_engine = SalesEngine.from_csv(
      items: './data/items.csv',
      merchants: './data/merchants.csv',
      invoices: './data/invoices.csv',
      customers: './data/customers.csv',
      invoice_items: './data/invoice_items.csv',
      transactions: './data/transactions.csv'
    )
    assert_instance_of SalesAnalyst, sales_engine.analyst
  end

  def test_invoices_creates_repository_of_invoices
    sales_engine = SalesEngine.from_csv(invoices: './data/invoices.csv')
    assert_instance_of InvoiceRepository, sales_engine.invoices
  end

  def test_invoices_items_creates_repository_of_invoice_items
    sales_engine = SalesEngine.from_csv(invoice_items: './data/invoice_items.csv')
    assert_instance_of InvoiceItemRepository, sales_engine.invoice_items
  end

  def test_transactions_creates_repository_of_transactions
    sales_engine = SalesEngine.from_csv(transactions: './data/transactions.csv')
    assert_instance_of TransactionRepository, sales_engine.transactions
  end

  def test_customers_creates_repository_of_customers
    sales_engine = SalesEngine.from_csv(customers: './data/customers.csv')
    assert_instance_of CustomerRepository, sales_engine.customers
  end






end
