require File.expand_path('../spec_helper.rb', __FILE__)

require 'rubygems'
require 'rake'
require 'magic_loader/tasks'

example_output = File.expand_path('../../tmp/example.rb')

describe MagicLoader::Task do
  before :all do
    @sources = File.expand_path('../fixtures/resolvable', __FILE__)
    rm_f example_output
  end
  
  it "prints to standard output unless a :target is specified" do
    # It's left as an exercise to the end user to visually confirm this
    MagicLoader::Task.new @sources
    Rake::Task['magicload'].invoke
  end  
end