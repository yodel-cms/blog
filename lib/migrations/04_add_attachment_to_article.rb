class BlogAddAttachmentsToArticleMigration < Migration
  def self.up(site)
    site.articles.modify do |articles|
      add_field :attachment, :attachment
      remove_field :blog
    end
    
    site.blogs.modify do |articles|
      remove_field :blog
    end
  end
  
  def self.down(site)
    site.pages.create_model :articles do |articles|
      add_field :blog, :alias, of: :parent
      remove_field :attachment
    end
    
    site.blogs.create_model :articles do |articles|
      add_field :blog, :alias, of: :parent
    end
  end
end
