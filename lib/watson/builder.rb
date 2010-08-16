class Builder

  def build(dir)
    if File.exist?(dir + "/wiki")
      puts  "Already something there"
      exit
    end
    Dir.chdir(dir)
    FileUtils.mkdir("wiki")
    Dir.chdir("wiki")
    FileUtils.mkdir("_layouts")
#    FileUtils.touch("_layouts/layout.html")
    File.open("_layouts/layout.html", "w") { |f| f.puts " {{ content }}" }
    FileUtils.mkdir("notes")
  end

end
