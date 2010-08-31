require File.expand_path('../spec_helper.rb', __FILE__)

require 'rubygems'
require 'rake'
require 'magic_loader/tasks'

describe MagicLoader::Task do
  before :all do
    @prefix  = File.dirname(__FILE__) + '/fixtures/'
    @sources = @prefix + 'resolvable'
    @output  = File.expand_path('../tmp/example.rb', __FILE__)
  end
  
  before :each do
    rm @output if File.exists? @output
    File.exists?(@output).should be_false
  end
  
  it "prints to standard output unless a :target is specified" do
    # It's left as an exercise to the end user to visually confirm this
    MagicLoader::Task.new @sources, :strip => @prefix
    Rake::Task['magicload'].invoke
  end
  
  it "creates new files if they don't exist" do
    MagicLoader::Task.new @sources,
      :target => @output,
      :strip  => @prefix,
      :name   => 'magicload2'
      
    Rake::Task['magicload2'].invoke
    
    File.exists?(@output).should be_true
  end
  
  it "annotates files that do exist" do
    important_crap = "# OMFG IMPORTANT CRAP DON'T DELETE THIS"
    File.open(@output, 'w') { |f| f << important_crap }
    
    MagicLoader::Task.new @sources,
      :target => @output,
      :strip  => @prefix,
      :name   => 'magicload3'
      
    Rake::Task['magicload3'].invoke

    File.exists?(@output).should be_true
    data = File.read @output
    data[important_crap].should be_an_instance_of(String)
  end
  
  it "annotates files that do exist and already have magic blocks" do
    important_crap = "# OMFG IMPORTANT CRAP DON'T DELETE THIS"
    fake_magic_block = [
      MagicLoader::BEGIN_MAGIC,
      "# omgfake!",
      MagicLoader::END_MAGIC
    ].join("\n")
    
    important_crap << "\n\n" << fake_magic_block
    File.open(@output, 'w') { |f| f << important_crap }
  end
end