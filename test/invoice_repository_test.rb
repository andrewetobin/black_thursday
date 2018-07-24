require './test/test_helper'
require './lib/invoice_repository'
require './lib/file_loader'

class InvoiceRepositoryTest < Minitest::Test
  include FileLoader

  def setup
    @invrepo = InvoiceRepository.new(load_file('./data/invoices.csv'))
  end

  def test_it_exists
    assert_instance_of InvoiceRepository, @invrepo
  end
end
