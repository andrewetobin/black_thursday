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

  def average_invoices_per_merchant
    total = merchant_id_counts_in_array.inject(0) do |sum, number|
      sum += number
    end
    (total / number_merchant_ids_in_invoices).round(2)
  end

  def merchant_ids_invoices_hash
    @sales_engine.invoices.repo.group_by do |invoice|
      invoice.merchant_id
    end
  end


  def merchant_id_counts_in_array
    merchant_ids_invoices_hash.map do |key, value|
      value.count.to_f
    end
  end

  def number_merchant_ids_in_invoices
    merchant_ids_invoices_hash.values.count
  end

  def invoice_paid_in_full?(invoice_id)
    searched_transaction = @sales_engine.transactions.find_all_by_invoice_id(invoice_id)
    searched_transaction.any? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_total(invoice_id)
    searched_invoice_items = @sales_engine.invoice_items.find_all_by_invoice_id(invoice_id)
    costs = searched_invoice_items.map do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price
    end
    number = costs.inject(0) do |total, cost|
      total + cost
    end
    BigDecimal(number, 7)
  end

  def average_invoices_per_merchant_standard_deviation
    x = sum_minus_mean.inject(0) do |sum, number|
      sum += number
    end/number_merchant_ids_in_invoices
    Math.sqrt(x).round(2)
  end

  def sum_minus_mean#array
    merchant_id_counts_in_array.map do |number|
      (number - average_invoices_per_merchant) ** 2
    end
  end

  def two_sd_above_average_invoice_per_merchant_id
    (average_invoices_per_merchant_standard_deviation * 2) +
      average_invoices_per_merchant
  end

  def top_merchants_by_invoice_count
    x = two_sd_above_average_invoice_per_merchant_id
     invoices_per_merchant.map do |id, count|
     @sales_engine.merchants.find_by_id(id) if count >= x
   end.compact
  end

  def invoices_per_merchant
    invoices_per_merchant = Hash.new(0)
    merchant_ids_invoices_hash.each do |m_id, invoice|
      invoices_per_merchant[m_id] = invoice.count
    end
    invoices_per_merchant
  end

  def bottom_merchants_by_invoice_count
    x = two_sd_below_average_invoice_per_merchant_id
     invoices_per_merchant.map do |id, count|
     @sales_engine.merchants.find_by_id(id) if count < x
   end.compact
  end

  def two_sd_below_average_invoice_per_merchant_id
    average_invoices_per_merchant -
    (average_invoices_per_merchant_standard_deviation * 2)
  end

  def top_days_by_invoice_count
    high_count = average_invoices_per_day_of_week + sd_invoices_per_day
    invoice_number_by_day_hash.map do |day, count|
      day if count >= high_count
    end.compact
  end

  def invoice_objects_by_day_hash
    @sales_engine.invoices.all.group_by do |invoice|
      invoice.created_at.strftime('%A')
    end
  end

  def invoice_number_by_day_hash
    invoice_by_day_hash = {}
    invoice_objects_by_day_hash.each do |day, invoices|
      invoice_by_day_hash[day] = invoices.count
    end
    invoice_by_day_hash
  end

  def average_invoices_per_day_of_week
    invoices_per_day = invoice_number_by_day_hash.values
    x = invoices_per_day.inject(0) do |total, invoices|
      total += invoices
    end/7
  end

  def sd_invoices_per_day
    array = invoice_number_by_day_hash.values
    average = average_invoices_per_day_of_week
    x = standard_deviation(array, average)
  end

  def invoice_status(status)
    decimal = invoices_by_shipping_status[status]
    (decimal.to_f / total_invoices * 100).round(2)
  end

  def invoices_by_shipping_status
    x = @sales_engine.invoices.all.group_by do |invoice|
      invoice.status
    end
    y = x.each do |status, invoices|
      x[status] = invoices.count
    end
  end

  def total_invoices
    invoices_per_day = invoice_number_by_day_hash.values
    x = invoices_per_day.inject(0) do |total, invoices|
      total += invoices
    end
  end

  def total_revenue_by_date(date)
    invoices = @sales_engine.invoices.all.find_all do |invoice|
      invoice.created_at.to_s[0...10] == date.to_s[0...10]
    end
    invoice_ids = invoices.map do |invoice|
      invoice.id
    end
    total_revenue(invoice_ids)
  end

  def total_revenue(invoice_ids)
    total_revenue = invoice_ids.inject(0) do |total, invoice_id|
      total += invoice_total(invoice_id.to_f)
    end
  end

  def revenue_by_merchant(merchant_id)
    merchant_invoices = @sales_engine.invoices.find_all_by_merchant_id(merchant_id)
    invoice_array = merchant_invoices.map do |invoice|
      invoice.id
    end
    total_revenue(invoice_array)
  end





  def invoices_grouped_by_merchant
    @sales_engine.invoices.all.group_by do |invoice|
      invoice.merchant_id
    end
  end

  

end
