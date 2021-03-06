require_relative 'repo_helper'
require_relative 'customer'

class CustomerRepository
  include RepoHelper
  attr_reader :repo

  def initialize(file_contents)
    @repo = file_contents.map do |customer|
      Customer.new(customer)
    end
  end

  def find_all_by_first_name(name)
    @repo.find_all do |customer|
      customer.first_name.downcase.include?(name.downcase)
    end
  end

  def find_all_by_last_name(name)
    @repo.find_all do |customer|
      customer.last_name.downcase.include?(name.downcase)
    end
  end

  def create(attributes)
    max_id = @repo.max_by do |customer|
      customer.id
    end # this returns the complete merchant object with highest id
    new_id = (max_id.id + 1).to_i
    attributes[:id] = new_id
    @repo << Customer.new(attributes)
  end

  def update(id, attributes)
    customer = find_by_id(id)
    return if customer.nil?
    attributes.each do |key, value|
      customer.first_name = value if key == :first_name
      customer.last_name = value if key == :last_name
    end
    customer.updated_at = Time.now + 1
    customer
  end

  def inspect
    "#<#{self.class} #{@repo.size} rows>"
  end



end
