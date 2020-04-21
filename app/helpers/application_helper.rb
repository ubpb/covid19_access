module ApplicationHelper

  def active_when(regexp_or_boolean)
    if regexp_or_boolean.is_a?(Regexp)
      regexp = regexp_or_boolean
      request.path =~ regexp ? "active" : ""
    else
      regexp_or_boolean == true ? "active" : ""
    end
  end

end
