require './test/test_helper'
require './lib/transaction_repository'
require './lib/file_loader'

class TransactionRepositoryTest < Minitest::Test
  include FileLoader

  def setup
    @transaction_repo = TransactionRepository.new(load_file('./data/transactions.csv'))
    @attributes = {
      invoice_id: 14,
      credit_card_number: '4347424542425242',
      credit_card_expiration_date: '0720',
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

  def test_it_can_find_all_by_invoice_id
    assert_equal 2, @transaction_repo.find_all_by_invoice_id(3392).count
    assert_equal [], @transaction_repo.find_all_by_invoice_id(89231)
  end

  def test_it_can_find_all_by_credit_card_number
    assert_equal 1, @transaction_repo.find_all_by_credit_card_number('4283701184969401').count
    assert_equal [], @transaction_repo.find_all_by_credit_card_number('4283701184969402')
  end

  def test_it_can_find_all_by_result
    assert_equal 4158, @transaction_repo.find_all_by_result(:success).count
    assert_equal 827, @transaction_repo.find_all_by_result(:failed).count
    assert_equal [], @transaction_repo.find_all_by_result(:pending)
  end

  def test_it_can_create_a_new_entry
    assert_equal 4985, @transaction_repo.repo.last.id
    @transaction_repo.create(@attributes)
    assert_equal 4986, @transaction_repo.repo.last.id
  end

  def test_it_can_update_an_entry
    @transaction_repo.create(@attributes)
    original_time = @transaction_repo.find_by_id(10).updated_at
    new_attributes = {
      credit_card_number: '1434623812342234',
      credit_card_expiration_date: '0178',
      result: 'failure'
    }
    @transaction_repo.update(10, new_attributes)
    assert_equal '1434623812342234', @transaction_repo.find_by_id(10).credit_card_number
    assert_equal '0178', @transaction_repo.find_by_id(10).credit_card_expiration_date
    assert_equal 'failure', @transaction_repo.find_by_id(10).result
    assert @transaction_repo.find_by_id(10).updated_at > original_time
  end

  def test_it_can_delete
    assert_equal @transaction_repo.all[4], @transaction_repo.find_by_id(5)
    @transaction_repo.delete(5)

    assert_equal nil, @transaction_repo.find_by_id(5)
  end




end
