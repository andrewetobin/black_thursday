require './test/test_helper'
require './lib/transaction'

class TransactionTest < Minitest::Test

  def setup
    @transaction = Transaction.new(
      id: 6,
      invoice_id: 8,
      credit_card_number: 4242424242424242,
      credit_card_expiration_date: '0220',
      result: 'success',
      created_at: '2018-07-24 13:37:32 -0600',
      updated_at: '2018-07-24 13:39:12 -0600'
    )
  end

  def test_it_exists
    assert_instance_of Transaction, @transaction
  end



end
