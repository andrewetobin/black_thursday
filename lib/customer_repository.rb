require_relative 'repo_helper'
require_relative 'customer'

class CustomerRepository
  include RepoHelper

  def initialize(file_contents)
    @repo = file_contents.map do |customer|
      Customer.new(customer)
    end
  end




end
