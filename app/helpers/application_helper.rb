module ApplicationHelper

  def active_when(regexp_or_boolean)
    if regexp_or_boolean.is_a?(Regexp)
      regexp = regexp_or_boolean
      request.path =~ regexp ? "active" : ""
    else
      regexp_or_boolean == true ? "active" : ""
    end
  end

  def mask_barcode(barcode)
    if barcode.present?
      barcode.dup.tap { |p| r = (4..p.size-3) ; p[r] = r.size.times.map{'*'}.join }
    else
      "n.n."
    end
  end

end
