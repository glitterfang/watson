class Generator
  require "rdiscount"
  require "fileutils"
  require "Pathname"

  class NoSuchDirectory < NameError; end
  class NoSuchNotes < ArgumentError; end
  class NoSuchLayout < ArgumentError; end

  attr_accessor :directory, :layout, :notes, :options



  def initialize(options)
    @directory = File.expand_path(options['source'])
    if @directory.nil?
      raise NoSuchDirectory,"you need to specify a directory"
    end
    self.options = options

    unless File.exists?(@directory)
      raise NoSuchDirectory, "no such directory, #{@directory}" 
    end
  
  end

  def load_layout
    @layout = Dir.glob("#{@directory}/_layouts/*.html")
    if @layout.count < 1
      raise NoSuchLayout, "no such layout" 
    end
  end

  def load_notes
   @notes = Dir.glob("#{@directory}/notes/*.mdown")
   if @notes.count < 1
     raise NoSuchNotes, "you don't have any notes!"
   end
   @notes
  end
  
  def wiki_directory
    @directory + "/wiki"
  end

  def load_everything
    load_layout
    load_notes
  end
  
  def generate_wiki
    unless wiki_exists? 
      make_wiki_folder
    end  
    
    markup_notes
 end
  
  def wiki_exists?
    if File.exist?("#{self.directory}/wiki")
      true
    else
      false
    end
  end

  def make_wiki_folder
    FileUtils.mkdir("#{self.directory}/wiki") unless wiki_exists?
  end
  
  def clean_name(fullname)

   name = Pathname.new(fullname).basename.to_s

    /(\.\w+)/ =~ name
    file_type =  Regexp.last_match(0)  
   name.gsub(/#{file_type}/, "")
  end


  def markup_notes
    load_notes
    load_layout

    @notes.reject  { |x| !x.match(/\w+\.\w+/) }


    @notes.each do |note|
      content = ""
      File.open(note) { |f| content = RDiscount.new(f.read).to_html }
      File.open("#{@directory}/wiki/#{clean_name(note)}" + ".html", "w") { |f| f.puts thread_layout(content) }
      
    end
  end

  def thread_layout(note)
    layout = File.open(@layout.first) { |f| f.read }
    layout.gsub(/{{ content }}/, note) 
  end

end
