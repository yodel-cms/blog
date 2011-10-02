class ArticleModelMigration < Migration
  def self.up(site)
    site.pages.create_model :articles do |articles|
      add_field :published, :time
      add_field :tags, :tags
      add_field :blog, :alias, of: :parent
      add_field :search_title, :function, fn: 'format("News: {{title}}")'
      add_one   :author, model: :user
      articles.allowed_parents = [site.blogs]
    end
    
    site.blogs.modify do |blogs|
      blogs.allowed_children = [site.articles]
    end
  end
  
  def self.down(site)
    site.articles.destroy
  end
end
