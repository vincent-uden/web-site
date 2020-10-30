class SiteStats < Table
    set_table_name 'site_stats'
    add_column :id, :int, :prim_key
    add_column :visits, :int

    def initialize(db_hash)
        super()

        set_id db_hash['id']
        set_visits db_hash['visits']
    end

    def self.get
        select_all({})[0]
    end

    def self.add_visitor
        stats = get
        if stats.nil?
            stats = (SiteStats.new "id" => -1, "visits" => 0)
        end
        stats.set_visits (stats.get_visits + 1)
        stats.save
    end
end
