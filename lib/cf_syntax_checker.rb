# require "cf_syntax_checker/version"
require 'zip'
require 'pry'
require 'nokogiri'

module CfSyntaxChecker
  extend self

  class Error < StandardError; end
  # Your code goes here...

  def run
    Zip::File.open('../../Exercise-1.2.zip') do |zip_file|
      zip_file.each do |f|
        f_path = File.join('../../ExerciseFolderName', f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)

        if html_file?(f)
          loaded_file = File.open(f_path)
          file_contents = File.read(loaded_file)
          parsed_doc = Nokogiri::HTML::DocumentFragment.parse(file_contents)
          parsed_doc.errors.each do |e|
            puts "ERRORS: #{e.message}"
          end
          loaded_file.close
        end
      end
    end
  end

  private

  def html_file?(file)
    File.extname(file.name) == '.html'
  end
end
