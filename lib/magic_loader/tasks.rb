#--
# Copyright (C)2010 Tony Arcieri
# You can redistribute this under the terms of the MIT license
# See file LICENSE for details
#++

require 'magic_loader'
require 'rake/tasklib'

# Generates the MagicLoader rake task, which 
class MagicLoader::Task < Rake::TaskLib
  BEGIN_MAGIC = "#-----BEGIN MAGICLOADER MAGIC BLOCK-----"
  END_MAGIC   = "#------END MAGICLOADER MAGIC BLOCK------"
  MAGIC_WARNING = [
    "# Automagically generated by MagicLoader. Editing may",
    "# result in bad juju. Edit at your own risk!"
  ]
  MAGIC_REGEXP = /#{BEGIN_MAGIC}.*#{END_MAGIC}/
  
  def initialize(*paths)
    options = paths.last.is_a?(Hash) ? paths.pop : {}
    task_name = options[:name] || 'magicload'
    
    task task_name do
      load_order = MagicLoader.require_all(*paths)
      strip_paths!(load_order, options[:strip]) if options[:strip]

      magic_block = [
        BEGIN_MAGIC,
        MAGIC_WARNING,
        "# Run \"rake #{task_name}\" to regenerate",
        load_order.map { |t| "require #{t.dump}" },
        END_MAGIC
      ].flatten.join("\n")
      
      if options[:target]
        if File.exists? options[:target]
          annotate_file options[:target], magic_block
        else
          File.open(options[:target], "w") { |f| f << magic_block }
        end
      else
        puts magic_block
      end
    end
  end
  
  #######
  private
  #######
  
  # Implement the path stripping logic described in the README
  def strip_paths!(paths, to_strip)
    paths.map! do |path|
      case to_strip
      when String
        if path.index(to_strip) == 0
          path.sub to_strip, ''
        else
          path
        end
      when Regexp
        path.sub to_strip, ''
      else raise ArgumentError, ":strip given a #{to_strip.class}"
      end
    end
  end
  
  # Annotate a MagicLoader Magic Block onto the end of an existing file
  def annotate_file(path, magic_block)
    data = File.read path
    magic_matches = data.match(MAGIC_REGEXP)
    case magic_matches
    when MatchData
      raise "Sorry, I don't know how to annotate a file that already has a magic block"
    else
      data << "\n\n" << magic_block
    end
    
    File.open(path, 'w') { |f| f << data }
  end
end