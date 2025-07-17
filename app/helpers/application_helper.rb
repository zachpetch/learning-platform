module ApplicationHelper
  def page_title(title)
    content_for(:title, title)
    content_for(:header, title)
  end
end
