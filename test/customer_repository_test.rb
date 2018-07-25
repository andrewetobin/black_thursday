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

  def test_all_will_return_entire_repo
    assert_equal @customer_repo.repo, @customer_repo.all
  end

  def test_find_by_id_number
    assert_equal @customer_repo.all[25], @customer_repo.find_by_id(26)
    assert_nil @customer_repo.find_by_id(6521)
  end

  def test_it_can_find_all_by_first_name
    assert_equal [@customer_repo.all[664]], @customer_repo.find_all_by_first_name('Octavia')
    assert_equal [], @customer_repo.find_all_by_first_name('Tonoccus')
    assert_equal 21, @customer_repo.find_all_by_first_name('Ed').length
  end

  def test_it_can_find_by_last_name
    assert_equal [@customer_repo.all[798]], @customer_repo.find_all_by_last_name('Oberbrunner')
    assert_equal [], @customer_repo.find_all_by_last_name('Tobin')
    assert_equal 22, @customer_repo.find_all_by_last_name('son').length
  end





end
