module TagsHelper
  def tag_collection
    ActsAsTaggableOn::Tag.all.map do |tag|
      { id: tag.name, text: tag.name }
    end
  end
end
