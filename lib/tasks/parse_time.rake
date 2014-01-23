require 'nokogiri'
require 'open-uri'


namespace :bookit do
	desc "Parse studentportalen for whitelists"
	task parse: :environment do

		read_matchers

		doc = nokogiri_doc

		each_row doc do |row|
			next if Date.parse(row[:starts]).past?
			@rules.each do |r|
				create_item row, r if row[:title] =~ r[:regex]
			end
		end
	end

	desc "Clear automatically added tasks"
	task clear: :environment do
		puts "Clearing all automatically added tasks..."
		WhitelistItem.where("title like '%[AUTO]%'").delete_all
		puts "Done"
	end

	desc "Clear and re-parse the content"
	task reparse: [:clear, :parse]


	def nokogiri_doc
		uri = URI.parse "https://www.student.chalmers.se/sp/academic_year_list"
		today = Date.today
		year = today.month < 6 ? today.year - 1: today.year
		year = "#{year}/#{year + 1}"
		puts "Getting: #{year}"
		params = { search_ac_year: year }
		uri.query = URI.encode_www_form params

		Nokogiri::HTML(open uri)
	end

	def each_row(doc, &block)
		table_row = '//*[@id="contentpage"]/table/tr'
		doc.xpath(table_row).each do |tr|
			tds = tr.xpath('td')
			next if tds[0].content.empty? || tds[0].content.include?('Hösttermin') || tds[0].content.include?('Vårtermin')
			yield title: tds[0].try(:content), starts: tds[2].try(:content), ends: tds[4].try(:content)
		end
	end

	@rules = []

	def match(regex, times, options = {})
		rule = { 
			regex: regex,
			times: times,
			options: options
		}
		puts "Defined rule: #{rule[:regex].to_s} on: #{rule[:times]} with options: #{rule[:options]}"
		@rules << rule
	end

	def create_item(item, rule)
		defaults = {
			days: :weekdays,
			blacklist: false, 
			title: item[:title],
		}
		op = rule[:options].reverse_merge(defaults)

		rule[:times].each do |t|
			wi = WhitelistItem.create!({
				title: "#{op[:title]}[AUTO]",
				rule_start: item[:starts],
				rule_end: item[:ends],
				blacklist: op[:blacklist],
				days: op[:days],
				begin_time: t.split('-')[0],
				end_time: t.split('-')[1]
			})
			puts "Added: #{wi}"
		end
	end

	def read_matchers
		instance_eval File.read('config/matchers.rb')
	end
end
