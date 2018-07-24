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

  
end
