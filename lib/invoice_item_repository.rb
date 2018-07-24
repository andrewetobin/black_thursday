require_relative 'invoice_item'
require_relative 'repo_helper'

class InvoiceItemRepository
  include RepoHelper
  attr_reader :repo

  def initialize(file_contents)
    @repo = file_contents.map { |invoice_item| InvoiceItem.new(invoice_item) }
  end

  def find_all_by_item_id(id)
    @repo.select do |item_invoice|
      item_invoice.item_id == id
    end
  end

  def create(attributes)
    max_id = @repo.max_by do |invoice_item|
      invoice_item.id
    end # this returns the complete merchant object with highest id
    new_id = (max_id.id + 1).to_i
    attributes[:id] = new_id
    @repo << InvoiceItem.new(attributes)

  end




end
