require_relative 'file_loader'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'sales_analyst'
require_relative 'invoice_repository.rb'
require_relative 'invoice_item_repository.rb'
require_relative 'transaction_repository.rb'
require_relative 'customer_repository.rb'

class SalesEngine
  include FileLoader
  attr_reader :info

  def initialize(info)
    @info = info
  end

  def self.from_csv(info)
    new(info)
  end

  def items
    @items ||= ItemRepository.new(load_file(info[:items]))
  end

  def merchants
    @merchants ||= MerchantRepository.new(load_file(info[:merchants]))
  end

  def analyst
    @analyst = SalesAnalyst.new(self)
  end

  def invoices
    @invoices ||= InvoiceRepository.new(load_file(info[:invoices]))
  end

  def customers
    @customers ||= CustomerRepository.new(load_file(info[:customers]))
  end

  def invoice_items
    @invoice_items ||= InvoiceItemRepository.new(load_file(info[:invoice_items]))
  end

  def transactions
    @transactions ||= TransactionRepository.new(load_file(info[:transactions]))
  end




end
