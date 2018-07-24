require './test/test_helper'
require './lib/invoice_repository'
require './lib/file_loader'

class InvoiceRepositoryTest < Minitest::Test
  include FileLoader

  def setup
    @invrepo = InvoiceRepository.new(load_file('./data/invoices.csv'))
    @attributes = {customer_id: 999, merchant_id: 12335541, status: "returned", created_at: Time.now, updated_at: Time.now}
  end

  def test_it_exists
    assert_instance_of InvoiceRepository, @invrepo
  end

  def test_returns_all
    assert_instance_of Invoice, @invrepo.all[0]
    assert_instance_of Array, @invrepo.all
    assert_equal 4985, @invrepo.all.count
  end

  def test_find_by_id
    assert_equal @invrepo.all[-1], @invrepo.find_by_id(4985)
    assert_equal nil, @invrepo.find_by_id(9999)
  end

  def test_find_all_by_customer_id
    assert_equal 9, @invrepo.find_all_by_customer_id(999).count
    assert_equal [], @invrepo.find_all_by_customer_id(0000)
  end

  def test_find_all_by_merchant_id
    assert_equal 13, @invrepo.find_all_by_merchant_id(12335541).count
    assert_equal [], @invrepo.find_all_by_merchant_id(0000)
  end

  def test_find_all_by_status
    assert_equal 673, @invrepo.find_all_by_status("returned").count
    assert_equal [], @invrepo.find_all_by_status("none")
  end

  def test_create
    new_invoice = @invrepo.create({customer_id: "999", merchant_id: "12335541", status: "pending", created_at: Time.now, updated_at: Time.now})
    assert_instance_of Invoice, new_invoice
    assert_equal 4986, new_invoice.id
    assert_equal @invrepo.all[-1], new_invoice
  end

  def test_update
    @invrepo.update(4985, @attributes)
    assert_equal "returned", @invrepo.find_by_id(4985).status
  end

end
