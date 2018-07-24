require_relative 'invoice'
require_relative 'repo_helper'
require 'pry'

class InvoiceRepository
  include RepoHelper
  attr_reader :repo

  def initialize(csv_file)
    @repo = csv_file.map do |invoice|
      Invoice.new(invoice)
    end
  end

  def find_all_by_customer_id(id)
    @repo.find_all do |invoice|
      invoice.customer_id == id
    end
  end

  def find_all_by_merchant_id(id)
    @repo.find_all do |invoice|
      invoice.merchant_id == id
    end
  end

  def find_all_by_status
  end 


end
