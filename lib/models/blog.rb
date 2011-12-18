class Blog < Page
  attr_reader :number_of_pages, :page_params, :tag, :total_articles, :month, :year
  
  respond_to :get do
    with :html do
      articles
      super()
    end
    
    with :atom do |xml|
      @xml = xml
      layout('atom').render(self)
    end
  end
  
  def xml
    @xml
  end
  
  def articles
    return @articles if @articles
    query = site.articles.where(parent: id).order('published desc')
    
    # FIXME: merge in to search page
    if params['tag']
      @tag = params['tag']
      query = query.where(tags: @tag)
      @page_params = "tag=#{params['tag']}&"
    elsif params['month'] && params['year']
      @month = [[params['month'].to_i, 1].max, 12].min # constrain the month between 1..12
      @year  = params['year'].to_i
      query = query.where(:published.gte => Time.local(@year, @month, 1), :published.lte => Time.local(@year, @month + 1, 1))
      @page_params = "year=#{params['year']}&month=#{params['month']}&"        
    else
      @page_params = ''
    end
    
    @total_articles = query.count
    @number_of_pages = (@total_articles.to_f / articles_per_page).ceil
    query.limit(articles_per_page).skip(page_number * articles_per_page).all
  end
  
  def latest_articles(limit = 3)
    site.articles.where(parent: id).order('published desc').limit(limit).all
  end
  
  def first_page?
    page_number == 0
  end
  
  def last_page?
    page_number == (@number_of_pages - 1)
  end
  
  def page_number
    @page_number ||= params['page'].to_i
  end
  
  def tag_path(tag)
    "#{path}?tag=#{CGI::escape(tag || '')}"
  end
  
  def page_path(page_number)
    "#{path}?page=#{page_number}"
  end
  
  def previous_page_path
    if first_page?
      path
    else
      "#{path}?page=#{page_number - 1}"
    end
  end
  
  def next_page_path
    if last_page?
      path
    else
      "#{path}?page=#{page_number + 1}"
    end
  end
  
  def month_path(month, year)
    "#{path}?month=#{month}&year=#{year}"
  end

  def all_article_months
    counts = Hash.new(0)

    # generate a count of articles for each month
    children.each do |child|
      date = child.published.at_beginning_of_month
      counts[date] += 1
    end

    # collect the months into an array of counted values
    months = counts.each_pair.collect {|date, count| OpenStruct.new(date: date, count: count, path: month_path(date.month, date.year))}
    months.sort_by(&:date).reverse
  end

  def all_article_tags
    counts = Hash.new(0)

    # count the number of articles each tag appears in
    children.each do |child|
      child.tags.each do |tag|
        counts[tag] += 1
      end
    end

    # collect the tags into an array of counted values
    tags = counts.each_pair.collect {|tag, count| OpenStruct.new(tag: tag, count: count, path: tag_path(tag))}
    tags.sort_by(&:count).reverse
  end
end
