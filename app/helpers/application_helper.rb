module ApplicationHelper
  BASE_TITLE = 'Look For 1'
  def full_title(page_title = '')
    if page_title.empty?
      BASE_TITLE
    else
      "#{page_title} | #{BASE_TITLE}"
    end
  end

  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :success, :notice
      'alert-success'
    when :error, :alert
      'alert-danger'
    when :info
      'alert-info'
    when :warning
      'alert-warning'
    else
      flash_type.to_s
    end
  end
end
