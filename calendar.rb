require 'rubygems'
require 'sinatra'
require 'activesupport'
require 'haml'
require 'RMagick'

IMAGE_PATH = "#{ENV['PWD']}/public/images"


get '/' do  
  # @images = ImageGenerator.new
  # @images.setup
  
  year = (params[:year]) ? params[:year] : 2010
  @time = Time.mktime(year, "jan", 1, 1, 00, 00)
  haml :index
end

class ImageGenerator
  def setup
    @entries = Dir.entries(IMAGE_PATH)
    @entries.delete_if {|f| f =~ /^\.+$/ }
    remove_resized
    rename_orginals
    randomize_images
  end
  
  def remove_resized
    @entries.each do |file|
      if file =~ /resized$/
        File.delete("#{IMAGE_PATH}/#{file}")
        @entries.delete(file)
        puts "Deleted: #{file}"
      end
    end
  end
  
  def rename_orginals
    @entries.each do |file|
      next if file =~ /^pending/
      File.rename("#{IMAGE_PATH}/#{file}","#{IMAGE_PATH}/pending_#{file}")
      puts "Renamed Original #{file} -> pending_#{file}"
    end
  end
  
  def randomize_images
    @entries = Dir.entries(IMAGE_PATH)
    @entries = @entries.shuffle
    @entries.delete_if {|f| f !~ /^pending_/ }      
    rename_entries
  end
  
  def rename_entries
    1.upto(@entries.size) do |filenum|
      puts "Num: #{filenum}"
      file = @entries[filenum-1]
      File.rename("#{IMAGE_PATH}/#{file}","#{IMAGE_PATH}/#{filenum}.jpg")      
      puts "Renamed #{file} -> #{filenum}.jpg"
    end    
  end
    
end