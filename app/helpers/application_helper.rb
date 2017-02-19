module ApplicationHelper
  def format_url(url)
    url.starts_with?("http://") ? url : "http://#{url}"
  end

  def display_datetime(dt)
    if logged_in? && !current_user.time_zone.nil?
      dt = dt.in_time_zone(current_user.time_zone)
    end
    dt.strftime("%m/%d/%Y %l:%M%P %Z")
  end

  def create_vote_path(obj, *args)
    if obj.class == Post
      vote_post_path(obj, args[0])
    else
      vote_post_comment_path(params[:id] || params[:post_id], obj, args[0])
    end
  end

  def post_or_comment(obj)
    obj.class == Post ? "post_#{obj.slug}" : "comment_#{obj.id}"
  end
end
