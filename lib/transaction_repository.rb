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
    transaction = find_by_id(id)
    return if transaction.nil?
    attributes.each do |key, value|
      transaction.credit_card_number = value if key == :credit_card_number
      transaction.credit_card_expiration_date = value if key == :credit_card_expiration_date
      transaction.result = value if key == :result
      transaction.updated_at = Time.now + 1
    end
  end

  def inspect
    "#<#{self.class} #{@repo.size} rows>"
  end
end
