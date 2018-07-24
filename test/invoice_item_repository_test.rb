require './test/test_helper'
require './lib/invoice_item_repository'
require './lib/file_loader'

class InvoiceItemRepositoryTest < Minitest::Test
  include FileLoader

  def setup
    @invoice_item_repo = InvoiceItemRepository.new(load_file('./data/invoice_items.csv'))
    @attributes = {
      item_id: 7,
      invoice_id: 8,
      quantity: 1,
      unit_price: BigDecimal(10.99, 4),
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  def test_it_exists
    assert_instance_of InvoiceItemRepository, @invoice_item_repo
  end

  def test_all_invoice_item_repository
    assert_equal @invoice_item_repo.repo, @invoice_item_repo.all
  end

  def test_find_by_id_number
    assert_equal @invoice_item_repo.all[4], @invoice_item_repo.find_by_id(5)
    assert_equal nil, @invoice_item_repo.find_by_id(34212)
  end

  def test_find_all_by_item_id
    assert_equal 25, @invoice_item_repo.find_all_by_item_id(263553296).count
    assert_equal [], @invoice_item_repo.find_all_by_item_id(4523043)
  end

  def test_find_invoice_item_id
    assert_equal 6, @invoice_item_repo.find_all_by_invoice_id(3843).count
    assert_equal [], @invoice_item_repo.find_all_by_invoice_id(13637)
  end

  def test_it_can_create_new_invoice_item
    assert_equal 21830, @invoice_item_repo.repo.last.id
    @invoice_item_repo.create(@attributes)
    assert_equal 21831, @invoice_item_repo.repo.last.id
  end






end
