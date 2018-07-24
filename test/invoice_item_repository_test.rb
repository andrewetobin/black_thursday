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






end
