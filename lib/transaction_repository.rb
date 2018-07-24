require_relative 'transaction'
require_relative 'repo_helper'

class TransactionRepository
  include RepoHelper
  attr_reader :repo

  def initialize(file_contents)
    @repo = file_contents.map { |transaction| Transaction.new(transaction) }
  end





end
