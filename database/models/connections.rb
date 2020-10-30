class Connections < Table
  set_table_name 'connections'
  add_column :id, :int, :prim_key
  add_column :country, :int
  add_column :date, :string

  def initialize(db_hash)
    super()

    set_id db_hash['id']
    set_country db_hash['country']
    set_date db_hash['date']
  end

  def self.log_connection(ip)
    country = Countries.ip_to_country ip
    forbidden = [ "(Private Address)", "(Unknown Country?)" ]
    if forbidden.include? country.get_name
      return
    end
    c = Connections.new "id" => -1, "country" => country.get_id, "date" => DateTime.now.iso8601
    c.save
  end
end
