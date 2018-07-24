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

  def find_all_by_result(result)
    @repo.select do |transaction|
      transaction.result == result
    end
  end

  def create(attributes)
    max_id = @repo.max_by do |transaction|
      transaction.id
    end # this returns the complete merchant object with highest id
    new_id = (max_id.id + 1).to_i
    attributes[:id] = new_id
    @repo << Transaction.new(attributes)
  end

  def update(id, attributes)
    new_cc_num = attributes[:credit_card_number]
    new_expiration = attributes[:credit_card_expiration_date]
    new_result = attributes[:result]
    item = find_by_id(id)
    return if item.nil?
    item.updated_at = Time.now
    item.credit_card_number = new_cc_num
    item.credit_card_expiration_date = new_expiration
    item.result = new_result
  end




end
