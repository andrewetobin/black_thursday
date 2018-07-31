module MerchantAnalytics

  def merchants_with_only_one_item
    merchants = id_counts.delete_if do |merchant, count|
      count != 1
    end
    merchants.map do |merchant, count|
      @sales_engine.merchants.find_by_id(merchant)
    end
  end

  def id_counts
    group_items_by_merchant.keys.zip(count_items_by_merchant)
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

  def merchants_with_only_one_item_registered_in_month(month)
    merchants_in_month = merchants_grouped_by_month[month]
    one_item_in_month = merchants_with_only_one_item.select do |merchant|
      merchants_in_month.include?(merchant)
    end
    one_item_in_month
  end

  def most_sold_item_for_merchant(merchant_id)
    item_quantities = Hash.new(0)
    successful_items_per_merchant_id(merchant_id).map do |invoice_item|
      item_quantities[invoice_item.item_id] += invoice_item.quantity
    end
    high_item_from_ids_with_values(item_quantities)
  end

  def successful_items_per_merchant_id(merchant_id)
    all_invoices = @sales_engine.invoices.find_all_by_merchant_id(merchant_id)
    all_invoices.keep_if { |invoice| invoice_paid_in_full?(invoice.id) }
    all_invoices.map do |invoice|
      @sales_engine.invoice_items.find_all_by_invoice_id(invoice.id)
    end.flatten
  end

  def high_item_from_ids_with_values(hash)
    high_item_value = hash.values.max
    hash.keep_if do | key, value|
      value == high_item_value
    end
    hash.keys.map do |item_id|
      @sales_engine.items.find_by_id(item_id)
    end
  end

  def best_item_for_merchant(merchant_id)
    invoice_items = successful_items_per_merchant_id(merchant_id)
    item_id_unit_prices = invoice_items_with_total_price(invoice_items)
    high_item_from_ids_with_values(item_id_unit_prices).first
  end

  def high_item_from_ids_with_values(hash)
    high_item_value = hash.values.max
    hash.keep_if { | key, value| value == high_item_value }
    hash.keys.map { |item_id| @sales_engine.items.find_by_id(item_id) }
  end

  def merchants_grouped_by_month
    @sales_engine.merchants.all.group_by do |merchant|
      merchant.created_at.strftime('%B')
    end
  end

  def merchants_with_pending_invoices
    pendings = @sales_engine.invoices.all.map do |invoice|
      invoice.merchant_id unless invoice_paid_in_full?(invoice.id)
    end.compact
    pendings.map do |merchant_id|
      @sales_engine.merchants.find_by_id(merchant_id)
    end.uniq
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

  def top_revenue_earners(n = 20)
    merchants_and_revenue = hash_compact(total_revenue_per_merchant)
    merchants_and_revenue.keep_if do |merchant_id, revenue|
      merchants_and_revenue.values.sort[-n..-1].include?(revenue)
    end
    hash_to_array_by_value(merchants_and_revenue).map do |merchant_id|
      @sales_engine.merchants.find_by_id(merchant_id)
    end.reverse
  end

  def hash_compact(hash)
  hash.delete_if do |key, value|
    value.nil?
    end
  end

  def hash_to_array_by_value(hash)
  sorted_values = hash.values.sort
  array = []
  sorted_values.each do |value|
    hash.each do |x, y|
      array << x if y == value
    end
  end
  array.uniq
  end

  def total_revenue_per_merchant
      merchants = {}
      invoices_grouped_by_merchant.each do |merchant_id, invoices|
        merchants[merchant_id] = invoices.map do |invoice|
          invoice_total(invoice.id) if invoice_paid_in_full?(invoice.id)
        end.compact.inject(:+)
      end
      merchants
  end

  def invoices_grouped_by_merchant
    @sales_engine.invoices.all.group_by do |invoice|
      invoice.merchant_id
    end
  end
end
