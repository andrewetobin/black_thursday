require_relative 'invoice_item'
require_relative 'repo_helper'

class InvoiceItemRepository
  include RepoHelper
  attr_reader :repo 

  def initialize(file_contents)
    @repo = file_contents.map { |invoice_item| InvoiceItem.new(invoice_item) }
  end




end
