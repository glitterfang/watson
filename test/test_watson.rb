# Tophat's Test

require 'helper'
require 'tophat'

class TophatTest < Test::Unit::TestCase

   
  context "setting up the stage" do
   setup do
     @generator = Generator.new({ "source" => "test/wiki" })
     @generator.load_everything   
   end

   should "have a valid directory" do
    assert File.exist?(@generator.directory) 
   end

   should "have a layout" do
      assert_not_nil(@generator.layout)
   end
    
   should "have valid notes" do
    assert_not_nil(@generator.notes)
   end
  
  end
  
  context "handling errors" do
    setup do 
      @generator = Generator.new({ "source" => "test/fail_wiki" })
    end

     should "raise on invalid directory" do
       assert_raises(Generator::NoSuchDirectory) do 
        gen = Generator.new(({ "source" => "fucked_at_birth" }))
       end
     end

     should "raise on no layout" do
       
       assert_raise(Generator::NoSuchLayout) do
         @generator.layout
          @generator.load_layout
       end
     end

     should "raise on no notes" do
       assert_raise(Generator::NoSuchNotes) do
         @generator.load_notes
       end
     end
  end

  context "Making the wiki folder" do
    setup do
      @generator = Generator.new({ 'source' => "test/wiki" })
      if File.exist?("test/wiki")
        FileUtils.rmdir("test/wiki")
      end
    end
      
    should "make_wiki_folder" do 
      result = @generator.make_wiki_folder
      assert @generator.wiki_exists? 
    end

   
 end  

context "Parsing and writing the notes" do
    
     setup do
       @generator = Generator.new({ 'source' => 'test/wiki' })
     end
      
     should "parse notes throught markdown" do
     # @generator.load_notes.each do |note|
      # TODO: Need to add HTML regex to verify.
      #end
    end 
      
    should "save notes to wiki/" do
      # @generator  
     # @generator.generate_wiki
      @generator.make_wiki_folder
      @generator.markup_notes

      amount = @generator.notes.count  
      
      entries = Dir.entries("#{@generator.directory}/wiki")
      clean = entries.reject! { |x| !x.match(/\w+\.\w+/) }
      actual = entries.count

      assert_equal(amount, actual)
    end


  end
 



end

