class Routes < Table
  set_table_name 'routes'
  add_column :id, :int, :prim_key
  add_column :path, :string
  add_column :visits, :int

  def initialize(db_hash)
    super()

    set_id db_hash['id']
    set_path db_hash['path']
    set_visits db_hash['visits']
  end

  def self.log_route(path)
    route = (select_all where: "path = ?", values: [path])[0]
    if route.nil?
      route = Routes.new "id" => -1, "path" => path, "visits" => 0
    end
    route.set_visits (route.get_visits + 1)
    route.save
  end

  def self.get_history
    Database.select_all table_name, order_by: "visits DESC"
  end
end
