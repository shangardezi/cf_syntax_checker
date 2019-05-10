require 'bundler/inline'
require 'pry'

gemfile do
  source 'https://rubygems.org'
  gem 'rubyzip'
  gem 'colorize'
  gem 'nokogiri'
end

require 'colorize'
require 'zip'
require 'nokogiri'

zip_files = Dir.glob("./*.zip")
zip_files.each do |z|
  Zip::File.open(z) do |zip_file|
    zip_file.each do |f|
      f_path = File.join('./', f.name)
      FileUtils.mkdir_p(File.dirname(f_path))
      zip_file.extract(f, f_path) unless File.exist?(f_path)

      if File.extname(f.name) == '.html'
        loaded_file = File.open(f_path)
        file_contents = File.read(loaded_file)
        parsed_doc = Nokogiri::HTML::DocumentFragment.parse(file_contents)
        puts "   "
        parsed_doc.errors.each_with_index do |e, i|
          puts "File #{f.name}".colorize(:color => :white, :background => :red) if i == 0
          puts "Detected #{parsed_doc.errors.count} errors".colorize(:color => :white, :background => :red) if i == 0
          puts "#{e.message}".colorize(:color => :white, :background => :light_black)
        end
        puts "   "
        puts "   "
        loaded_file.close
      end
    end
  end
end

