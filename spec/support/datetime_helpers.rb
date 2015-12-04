module DateTimeHelpers
  def moment_js_parse(value)
    "moment('#{value}').format('YYYY-M-DD HH:mm Z')"
  end

  def event_date_standardized(datetime)
    datetime.strftime('%Y-%m-%d %H:%M%:z')
  end

  def event_date_parsed(datetime)
    parse_with_moment_js(event_date_standardized(datetime))
  end

  def parse_with_moment_js(value)
    page.evaluate_script(moment_js_parse(value))
  end

  def js_value(id)
    page.evaluate_script("$('#{id}').val()")
  end
end
