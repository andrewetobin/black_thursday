require 'time'

class Invoice
  attr_reader :attributes, :id, :customer_id, :merchant_id,
  :status, :created_at, :updated_at

  def initialize(hash = {})
    @attributes = {
      id:           hash[:id].to_i,
      customer_id:  hash[:customer_id].to_i,
      merchant_id:  hash[:merchant_id].to_i,
      status:       hash[:status],
      created_at:   hash[:created_at],
      updated_at:   hash[:updated_at]
    }
  end

  def id
    @attributes[:id]
  end

  def customer_id
    @attributes[:customer_id]
  end

  def merchant_id
    @attributes[:merchant_id]
  end

  def status
    @attributes[:status]
  end

  def created_at
    Time.parse(@attributes[:created_at].to_s)
  end

  def updated_at
    Time.parse(@attributes[:updated_at].to_s)
  end

end
