module RepoHelper

  def all
    @repo
  end

  def find_by_id(id)
    @repo.find do |object|
      id == object.id
    end
  end

  def find_by_name(name)
    @repo.find do |object|
      name.downcase == object.name.downcase
    end
  end

  def delete(id)
    object = find_by_id(id)
    @repo.delete(object)
  end

  def find_all_by_invoice_id(id)
    @repo.select do |item_invoice|
      item_invoice.invoice_id == id
    end
  end


end
