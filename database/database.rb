#!/usr/bin/env ruby

class Database
  @@db ||= SQLite3::Database.new './database/data.db'
  @@db.results_as_hash = true

  def self.execute(*args)
    @@db.execute(*args)
  end

  def self.drop_table(table)
    execute "DROP TABLE IF EXISTS #{table};"
  end

  def self.drop_tables(tables)
    tables.each do |t|
      drop_table t
    end
  end

  def self.create_tables(tables)
    if tables.include? 'site_stats'
      execute 'CREATE TABLE site_stats
      (id INTEGER PRIMARY KEY AUTOINCREMENT,
       visits INTEGER);'
    end
    if tables.include? 'blog_posts'
      execute 'CREATE TABLE blog_posts
      (id INTEGER PRIMARY KEY AUTOINCREMENT,
       name VARCHAR(100) NOT NULL,
       url VARCHAR(100) NOT NULL,
       upload_date VARCHAR(30) NOT NULL);'
    end
    if tables.include? 'quotes'
      execute 'CREATE TABLE quotes
      (id INTEGER PRIMARY KEY AUTOINCREMENT,
       text VARCHAR(255),
       originator VARCHAR(100));'
    end
    if tables.include? 'connections'
      execute 'CREATE TABLE connections
      (id INTEGER PRIMARY KEY AUTOINCREMENT,
       country INTEGER,
       date VARCHAR(100));'
    end
    if tables.include? 'countries'
      execute 'CREATE TABLE countries
      (id INTEGER PRIMARY KEY AUTOINCREMENT,
       name VARCHAR(255));'
    end
    if tables.include? 'routes'
      execute 'CREATE TABLE routes
      (id INTEGER PRIMARY KEY AUTOINCREMENT,
       path VARCHAR(255),
       visits INTEGER);'
    end
  end

  def self.table_exists?(table_name)
    # SELECT name FROM sqlite_master;
    (execute 'SELECT name FROM sqlite_master WHERE name = ?', table_name).length > 0
  end

  def self.insert(table_name, column_names, values)
    query = "INSERT INTO #{table_name} ("
    trimmed_values = []
    column_names.each_with_index do |c_name, i|
      if c_name != 'id'
        query += c_name + ", "
        trimmed_values << values[i]
      end
    end
    query = query[0..-3]
    query += ") VALUES ("
    column_names.each do |c_name|
      if c_name != 'id'
        query += "?, "
      end
    end
    query = query[0..-3]
    query += ");"
    # dp trimmed_values
    execute query, trimmed_values
  end

  def self.select_all(table_name, options)
    query = "SELECT * FROM #{table_name} "
    if options[:join]
      query += "JOIN #{options[:join]} "
      if options[:on]
        query += "ON #{options[:on]} "
      end
    end
    if options[:where]
      query += "WHERE #{options[:where]} "
    end
    if options[:order_by]
      query += "ORDER BY #{options[:order_by]} "
    end
    if options[:limit]
      query += "LIMIT #{options[:limit]} "
    end
    query += ";"
    if options[:debug]
      dp query
      dp options
    end
    execute query, options[:values]
  end
  
  def self.update(table_name, column_names, values)
    # The first column in both column_names and values are the identifying column
    query = "UPDATE #{table_name} SET "
    query = column_names.inject(query) do |acc, col|
      acc + col + " = ?, "
    end
    query = query[0..-3] # remove the last =?,

    query += " WHERE #{column_names[0]} = ?;"
    execute query, values + [values[0]]
  end
end
