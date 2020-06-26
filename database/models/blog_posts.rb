class BlogPosts < Table
  set_table_name 'blog_posts'
  add_column :id, :int, :prim_key
  add_column :name, :string
  add_column :url, :string
  add_column :upload_date, :string

  def initialize(db_hash)
    super()

    set_id db_hash['id']
    set_name db_hash['name']
    set_url db_hash['url']
    set_upload_date db_hash['upload_date']
  end

  def self.get_post_groups
    all_posts = select_all order_by: 'date(upload_date) DESC'
    last_month = all_posts[0].get_upload_date.split("-")[1]
    output = [[all_posts[0]]]
    i = 0
    all_posts[1..].each do |p|
      curr_month = p.get_upload_date.split("-")[1]
      if curr_month == last_month
        output[i] << p
      else
        i += 1
        output << []
        output[i] << p
        last_month = curr_month
      end
    end
    output
  end

  def get_day
    get_upload_date.split("-")[2]
  end

  def get_month
    c_table = {
      '01' => 'January',
      '02' => 'February',
      '03' => 'March',
      '04' => 'April',
      '05' => 'May',
      '06' => 'June',
      '07' => 'July',
      '08' => 'August',
      '09' => 'September',
      '10' => 'October',
      '11' => 'November',
      '12' => 'December'
    }
    c_table[get_upload_date.split("-")[1]]
  end

  def get_year
    get_upload_date.split("-")[0]
  end
end
