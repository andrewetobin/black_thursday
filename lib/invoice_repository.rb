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

  def find_all_by_status(status)
    @repo.find_all do |invoice|
      invoice.status == status
    end
  end

  def create(attributes)
    max_id = @repo.max_by do |invoice|
      invoice.id
    end
    new_id = max_id.id + 1
    attributes[:id] = new_id
    new_invoice = Invoice.new(attributes)

    @repo << new_invoice
    new_invoice
  end

end
