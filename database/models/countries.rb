class Countries < Table
  set_table_name 'countries'
  add_column :id, :int, :prim_key
  add_column :name, :string

  def initialize(db_hash)
    super()

    set_id db_hash['id']
    set_name db_hash['name']
  end

  def self.ip_to_country(ip_string)
    url = URI.parse("https://api.hostip.info/get_json.php?ip=#{ip_string}")
    req = Net::HTTP::Get.new url.to_s
    res = Net::HTTP.start(url.host, url.port, :use_ssl => true) do |http|
      http.request req
    end

    name = (JSON.parse res.body)["country_name"]
    rows = select_all(where: "name = ?", values: [ name ])
    if rows.empty?
      (Countries.new "id" => -1, "name" => name).save
      rows = select_all where: "name = ?", values: [ name ]
    end

    rows[0]
  end
end
