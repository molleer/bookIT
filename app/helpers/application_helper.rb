module ApplicationHelper

  def logout_path(return_to)
    return_to = "?return_to=#{return_to}" if return_to
    "#{Rails.configuration.account_ip}/logout#{return_to}"
  end

	def datetime_local_dateformat(date)
		date.strftime "%Y-%m-%dT%H:%M"
	end

	def swedish_day_names
		I18n.t(:'date.day_names').rotate
	end

	def active_weekdays(rule)
		rule.days_array.zip(swedish_day_names).select{ |active, dayname| active != 0 }.map{ |a, d| d }
	end

	def markdown(text)
    renderer = Redcarpet::Render::HTML
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end
