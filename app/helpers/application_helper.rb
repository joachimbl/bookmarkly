module ApplicationHelper
  def link_to_unless(condition, name, options = {}, html_options = {}, &block)
    if condition
      super
    else
      link_to(name, options, html_options, &block)
    end
  end
end
