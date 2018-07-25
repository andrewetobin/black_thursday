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

  def test_it_can_create_a_new_entry
    assert_equal 1000, @customer_repo.repo.last.id
    @customer_repo.create(@attributes)
    assert_equal 1001, @customer_repo.repo.last.id
  end

  def test_it_can_update_an_entry
    original_time = @customer_repo.find_by_id(34).updated_at
    new_attributes = {
      first_name: 'LeRoi',
      last_name: 'Moore',
    }
    @customer_repo.update(34, new_attributes)
    assert_equal 'LeRoi', @customer_repo.find_by_id(34).first_name
    assert_equal 'Moore', @customer_repo.find_by_id(34).last_name
    assert @customer_repo.find_by_id(34).updated_at > original_time
  end





end
