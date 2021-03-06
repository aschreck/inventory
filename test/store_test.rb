require "minitest/autorun"
require "minitest/pride"
require "./lib/store"
require "./lib/inventory"
require 'date'

class StoreTest < Minitest::Test

  def test_store_has_a_name
    store = Store.new("Hobby Town", "894 Bee St", "Hobby")

    assert_equal "Hobby Town", store.name
  end

  def test_store_has_a_type
    store = Store.new("Ace", "834 2nd St", "Hardware")

    assert_equal "Hardware", store.type
  end

  def test_store_has_a_location
    store = Store.new("Acme", "324 Main St", "Grocery")

    assert_equal "324 Main St", store.address
  end

  def test_store_tracks_inventories
    store = Store.new("Ace", "834 2nd St", "Hardware")

    assert_equal [], store.inventory_record
  end

  def test_store_can_add_inventories
    store = Store.new("Ace", "834 2nd St", "Hardware")
    inventory = Inventory.new('asdf')

    assert store.inventory_record.empty?

    store.add_inventory(inventory)

    refute store.inventory_record.empty?
    assert_equal inventory, store.inventory_record[-1]
  end

  def test_it_can_search_stock_for_an_item
    inventory1= Inventory.new(Date.new(2017, 9, 18))
    inventory1.record_item({"shirt" => {"quantity" => 50, "cost" => 15}})
    inventory2 = Inventory.new(Date.new(2017, 9, 18))
    inventory2.record_item({"shoes" => {"quantity" => 40, "cost" => 30}})

    acme = Store.new("Acme", "324 Main St", "Grocery")

    acme.add_inventory(inventory1)
    acme.add_inventory(inventory2)

    assert_equal 2, acme.inventory_record.length
    hash = {"quantity"=>50, "cost"=>15}
    assert_equal hash ,acme.stock_check("shirt")
  end

  def test_it_can_sort_inventories_by_date
    ace = Store.new("Ace", "834 2nd St", "Hardware")
    inventory1 = Inventory.new(Date.new(2017, 9, 13))
    inventory2 = Inventory.new(Date.new(2017, 9, 14))
    inventory3 = Inventory.new(Date.new(2017, 9, 16))
    inventory4 = Inventory.new(Date.new(2017, 9, 18))
    ace.add_inventory(inventory1)
    ace.add_inventory(inventory2)
    ace.add_inventory(inventory3)
    ace.add_inventory(inventory4)

    sorted_inventories = ace.sort_inventory_by_date

    assert_equal 18, sorted_inventories[0].date.day
    assert_equal 16, sorted_inventories[1].date.day
  end

  def test_it_can_tell_how_much_sold
    ace = Store.new("Ace", "834 2nd St", "Hardware")

    inventory3 = Inventory.new(Date.new(2017, 9, 16))
    inventory3.record_item({"hammer" => {"quantity" => 20, "cost" => 20}})

    inventory4 = Inventory.new(Date.new(2017, 9, 18))
    inventory4.record_item({"mitre saw" => {"quantity" => 10, "cost" => 409}})
    inventory4.record_item({"hammer" => {"quantity" => 15, "cost" => 20}})

    ace.add_inventory(inventory3)
    ace.add_inventory(inventory4)

    assert_equal 5, ace.amount_sold("hammer")
  end
end
