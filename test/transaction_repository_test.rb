require './test/test_helper'
require './lib/transaction_repository'
require './lib/file_loader'

class TransactionRepositoryTest < Minitest::Test
  include FileLoader

  def setup
    @transaction_repo = TransactionRepository.new(load_file('./data/transactions.csv'))
    @attributes = {
      invoice_id: 8,
      credit_card_number: '4242424242424242',
      credit_card_expiration_date: '0220',
      result: 'success',
      created_at: Time.now,
      updated_at: Time.now
      }
  end

  def test_it_exists
    assert_instance_of TransactionRepository, @transaction_repo
  end

  def test_all_will_return_entire_repository
    assert_equal @transaction_repo.repo, @transaction_repo.all
  end

  def test_it_can_find_by_id_number
    assert_equal @transaction_repo.all[4], @transaction_repo.find_by_id(5)
    assert_equal nil, @transaction_repo.find_by_id(89231)
  end




end
