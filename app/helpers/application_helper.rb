module ApplicationHelper
  def format_url(url)
    url.starts_with?("http://") ? url : "http://#{url}"
  end

  def display_datetime(dt)
    dt.strftime("%m/%d/%Y %l:%M%P %Z")
  end

  def create_vote_path(obj, *args)
    if obj.class == Post
      return vote_post_path(obj, args[0])
    else
      return vote_post_comment_path(obj[:post_id], obj, args[0])
    end
  end
end
