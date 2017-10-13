module ApplicationHelper
  def flash_class(level)
    "notification " << case level.to_sym
                       when :primary then "is-primary"
                       when :info    then "is-info"
                       when :success then "is-success"
                       when :warning then "is-warning"
                       when :danger  then "is-danger"
                       else ""
                       end
  end
end
