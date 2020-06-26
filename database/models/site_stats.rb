class SiteStats < Table
    set_table_name 'site_stats'
    add_column :id, :int, :prim_key
    add_column :visits, :int

    def initialize(db_hash)
        super()

        set_id db_hash['id']
        set_visits db_hash['visits']

        dp get_id
        dp get_visits
        dp self.class.get_columns.map { |c| c.name.to_s }
    end

    def self.get
        SiteStats.new (select_all({})[0])
    end

    def self.add_visitor
        stats = get
        stats.set_visits (stats.get_visits + 1)
        stats.save
    end
end