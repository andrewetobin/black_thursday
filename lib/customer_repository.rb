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





end
