require_relative 'sales_engine.rb'

class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def group_items_by_merchant
    @sales_engine.items.all.group_by do |item|
      item.merchant_id
    end
  end

  def count_items_by_merchant
    group_items_by_merchant.values.map do |value|
      value.count
    end
  end

  def average_items_per_merchant
    sum = count_items_by_merchant.inject(0) do |sum, number|
      sum += number
    end
    (sum / group_items_by_merchant.keys.count.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(count_items_by_merchant, average_items_per_merchant)
  end

  def standard_deviation(array, average)
    count_minus_one = (array.count - 1)
    sum = array.reduce(0.0) do |total, amount|
      total + (amount - average) ** 2
    end
    ((sum / count_minus_one) ** (1.0 / 2)).round(2)
  end

  def merchants_with_high_item_count
    deviation = average_items_per_merchant_standard_deviation
    average = average_items_per_merchant
    high_count = deviation + average

    merchant_id_paired_with_count.map do |merchant, count|
      @sales_engine.merchants.find_by_id(merchant) if count >= high_count
    end.compact
  end

  def merchant_id_paired_with_count
    group_items_by_merchant.keys.zip(count_items_by_merchant)
  end

  def average_item_price_for_merchant(id)
    items = @sales_engine.items.find_all_by_merchant_id(id)
    sum = items.reduce(0) { |total, item| total + item.unit_price }
    (sum / items.count).round(2)
  end

  def average_average_price_per_merchant
    sum = @sales_engine.merchants.all.reduce(0) do |total, merchant|
      total + average_item_price_for_merchant(merchant.id)
    end
    (sum / @sales_engine.merchants.repo.count).round(2)
  end

  def item_price_standard_deviation
    standard_deviation(all_item_prices, average_total_item_price).round(2)
  end

  def all_item_prices
    @sales_engine.items.all.map do |item|
      item.unit_price
    end
  end

  def average_total_item_price
    sum = @sales_engine.items.all.reduce(0) do |total, item|
      total + item.unit_price
    end
    sum / @sales_engine.items.all.count
  end

  def golden_items
    high_price = average_total_item_price + (item_price_standard_deviation * 2)
    @sales_engine.items.all.each_with_object([]) do |item, array|
      array << item if item.unit_price >= high_price
    end
  end

  def average_invoices_per_merchant#10.49
    total = merchant_id_counts_in_array.inject(0) do |sum, number|
      sum += number
    end
    (total / number_merchant_ids_in_invoices).round(2)
  end

  def merchant_ids_invoices_hash#hash
    @sales_engine.invoices.repo.group_by do |invoice|
      invoice.merchant_id
    end
  end  #returns a hash with each merchant_id as key and
    # each key has 1 array w/ every invoice instance as an index

  def merchant_id_counts_in_array#array with numbers of invoices per merchant_id
    merchant_ids_invoices_hash.map do |key, value|
      value.count.to_f
    end
  end

  def number_merchant_ids_in_invoices #475
    merchant_ids_invoices_hash.values.count
  end







end
