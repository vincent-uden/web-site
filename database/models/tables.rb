class Column
  attr_reader :name, :data_type, :prim_key
  def initialize(name, data_type, options={})
    @name      = name
    @data_type = data_type
    @prim_key  = options[:prim_key]
  end

  def to_s
    output = "-Column-\n"
    instance_variables.map do |var|
      output += " " + var.to_s[1..var.length - 1] + ": " + (instance_variable_get var).to_s + "\n"
    end

    output
  end
end

class Table
  def initialize
    @column_values = [] 
  end

  def self.set_table_name(t)
    @table_name = t
  end

  def self.table_name
    @table_name
  end

  def self.add_column(name, data_type, *args)
    if @columns == nil
      @columns = []
    end
    if args.include? :prim_key
      @columns << Column.new(name, data_type, prim_key: true)
    else
      @columns << Column.new(name, data_type)
    end
  end

  def self.get_columns
    @columns
  end

  def method_missing(method_name, *args, &blk)
    if method_name.to_s[0..3] == "get_"
      col_name = method_name.to_s[4..-1]
      self.class.get_columns.each_with_index do |col, index|
        if col.name == col_name.to_sym
          return @column_values[index]
        end
      end
      raise "Column #{col_name} does not exist"
    elsif method_name.to_s[0..3] == "set_"
      col_name = method_name.to_s[4..-1]
      self.class.get_columns.each_with_index do |col, index|
        if col.name == col_name.to_sym
          @column_values[index] = args[0]
          return
        end
      end
      puts "### #{method_name} ###"
      raise "Column #{col_name} does not exist"
    end
    super(method_name, *args, &blk)
  end

  def self.insert(values)
    Database.insert table_name, get_columns.map { |c| c.name.to_s }, values
  end

  def self.select_all(options)
    (Database.select_all table_name, options).map { |result| self.new(result) }
  end

  def save()
    if self.class.get_columns[0].name != :id
      raise "Table has no id column"
    end
    if (self.class.select_all where: "id = #{get_id}", debug: true).length == 0
      dp @column_values
      self.class.insert @column_values
    else
      Database.update(self.class.table_name, self.class.get_columns.map { |c| c.name.to_s }, @column_values)
    end
  end
end
