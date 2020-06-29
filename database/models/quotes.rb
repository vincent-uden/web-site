class Quotes < Table
  set_table_name 'quotes'
  add_column :id, :int, :prim_key
  add_column :text, :string
  add_column :originator, :string

  def initialize(db_hash)
    super()

    set_id db_hash['id']
    set_text db_hash['text']
    set_originator db_hash['originator']
  end

  def self.random
    (select_all order_by: "RANDOM()", limit: "1")[0]
  end

  def self.get_all
    select_all order_by: "originator ASC"
  end
end
