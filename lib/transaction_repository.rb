require_relative 'transaction'
require_relative 'repo_helper'

class TransactionRepository
  include RepoHelper
  attr_reader :repo

  def initialize(file_contents)
    @repo = file_contents.map { |transaction| Transaction.new(transaction) }
  end

  def find_all_by_credit_card_number(cc_number)
    @repo.select do |transaction| transaction.credit_card_number == cc_number
    end 
  end





end
