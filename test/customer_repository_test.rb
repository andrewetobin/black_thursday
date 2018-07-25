require './test/test_helper.rb'
require './lib/file_loader.rb'
require './lib/customer_repository.rb'

class CustomerRepositoryTest < Minitest::Test
  include FileLoader

  def setup
    @customer_repo = CustomerRepository.new(load_file('./data/customers.csv'))
    @attributes = {
      first_name: 'David',
      last_name: 'Grohl',
      created_at: Time.now,
      updated_at: Time.now
    }
  end

  def test_it_exists
    assert_instance_of CustomerRepository, @customer_repo
  end





end
