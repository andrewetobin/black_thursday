require_relative 'invoice_item'
require_relative 'repo_helper'

class InvoiceItemRepository
  include RepoHelper

  def initialize(file_contents)
    @repository = file_contents.map { |invoice_item| InvoiceItem.new(invoice_item) }
  end




end
