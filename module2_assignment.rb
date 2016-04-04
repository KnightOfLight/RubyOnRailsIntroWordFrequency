class LineAnalyzer
	attr_reader :highest_wf_count, :highest_wf_words, :content, :line_number

	def initialize(content, line_number)
		@content = content
		@line_number = line_number
		calculate_word_frequency
	end

	def calculate_word_frequency
		@highest_wf_words = Array.new
		@highest_wf_count = 0
		hash = Hash.new
		@content.split(" ").each { |word| hash[word.downcase].nil? ? hash[word.downcase] = 1 : hash[word.downcase] += 1 }
		hash.each { |key, val| @highest_wf_count = val if @highest_wf_count < val }
		hash.delete_if { |key, value| value != @highest_wf_count }
		hash.each { |key, value| @highest_wf_words << key }
	end
end

class Solution
	attr_reader :analyzers, :highest_count_across_lines, :highest_count_words_across_lines

	def initialize
		@analyzers = []
	end

	def analyze_file
		if File.exist? 'test.txt'
			@analyzers = Array.new

			File.foreach( 'test.txt' ) do |line|
				@analyzers.push( LineAnalyzer.new(line.chomp, analyzers.length + 1) )
			end

		end
	end

	def calculate_line_with_highest_frequency
		@highest_count_words_across_lines = []

		@analyzers.each do |line_analyzer|
			@highest_count_across_lines ||= line_analyzer.highest_wf_count
			@highest_count_across_lines = line_analyzer.highest_wf_count if @highest_count_across_lines < line_analyzer.highest_wf_count
		end

		@analyzers.each do |line_analyzer|
			@highest_count_words_across_lines << line_analyzer if line_analyzer.highest_wf_count == @highest_count_across_lines
		end
	end

	def print_highest_word_frequency_across_lines
		p "The following words have the highest word frequency per line:"

		@analyzers.each do |item|
			temp = nil

			item.highest_wf_words.each do |key, value|
				temp.nil? ? temp = key : temp += ", #{key}"
			end

			p "#{temp} appears in line #{item.line_number}"
		end
	end
end


