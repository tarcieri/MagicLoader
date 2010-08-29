require File.expand_path('../../lib/magic_loader.rb', __FILE__)

describe MagicLoader do    
  describe "dependency resolution" do
    it "handles load ordering when dependencies are resolvable" do
      MagicLoader.require_all File.expand_path('../fixtures/resolvable/*.rb', __FILE__)
    
      defined?(A).should == "constant"
      defined?(B).should == "constant"
      defined?(C).should == "constant"
      defined?(D).should == "constant"
    end
  
    it "raises NameError if dependencies can't be resolved" do
      proc do 
        MagicLoader.require_all File.expand_path('../fixtures/unresolvable/*.rb', __FILE__)
      end.should raise_error(NameError)
    end
  end
  
  describe "syntactic sugar" do
    before :each do
      @base_dir = File.expand_path('../fixtures/resolvable', __FILE__)
      @file_list = ['b.rb', 'c.rb', 'a.rb', 'd.rb'].map { |f| "#{@base_dir}/#{f}" }   
    end
    
    it "works like a drop-in require replacement" do
      MagicLoader.require_all(@base_dir + '/c').should be_true
    end
    
    it "accepts lists of files" do
      MagicLoader.require_all(@file_list).should be_true
    end
    
    it "is totally cool with a splatted list of arguments" do
      MagicLoader.require_all(*@file_list).should be_true
    end
    
    it "will load all .rb files under a directory without a trailing slash" do
      MagicLoader.require_all(@base_dir).should be_true
    end
    
    it "will load all .rb files under a directory with a trailing slash" do
      MagicLoader.require_all("#{@base_dir}/").should be_true
    end
  end
end