#--
# Copyright (C)2009-10 Tony Arcieri
# You can redistribute this under the terms of the MIT license
# See file LICENSE for details
#++

module MagicLoader
  # A wonderfully simple way to load your code.
  #
  # The easiest way to use require_all is to just point it at a directory
  # containing a bunch of .rb files.  These files can be nested under 
  # subdirectories as well:
  #
  #  MagicLoader.require_all 'lib'
  #
  # This will find all the .rb files under the lib directory and load them.
  # The proper order to load them in will be determined automatically.
  #
  # If the dependencies between the matched files are unresolvable, it will 
  # throw the first unresolvable NameError.
  #
  # You can also give it a glob, which will enumerate all the matching files: 
  #
  #  MagicLoader.require_all 'lib/**/*.rb'
  #
  # It will also accept an array of files:
  # 
  #  MagicLoader.require_all Dir.glob("blah/**/*.rb").reject { |f| stupid_file(f) }
  # 
  # Or if you want, just list the files directly as arguments:
  #
  #  MagicLoader.require_all 'lib/a.rb', 'lib/b.rb', 'lib/c.rb', 'lib/d.rb'
  #
  def self.require_all(*args)
    # Handle passing an array as an argument
    args.flatten!
    
    if args.size > 1
      # Expand files below directories
      files = args.map do |path|
        if File.directory? path
          Dir[File.join(path, '**', '*.rb')]
        else
          path
        end
      end.flatten
    else
      arg = args.first
      begin
        # Try assuming we're doing plain ol' require compat
        stat = File.stat(arg)
        
        if stat.file?
          files = [arg]
        elsif stat.directory?
          files = Dir.glob File.join(arg, '**', '*.rb')
        else
          raise ArgumentError, "#{arg} isn't a file or directory"
        end
      rescue Errno::ENOENT
        # If the stat failed, maybe we have a glob!
        files = Dir.glob arg
        
        # Maybe it's an .rb file and the .rb was omitted
        if File.file?(arg + '.rb')
          require(arg + '.rb')
          return true
        end
        
        # If we ain't got no files, the glob failed
        raise LoadError, "no such file to load -- #{arg}" if files.empty?
      end
    end

    # If there's nothing to load, you're doing it wrong!
    raise LoadError, "no files to load" if files.empty?
    
    # Sort input files to give semi-deterministic results
    files.sort!
    
    # Store load order as it's calculated
    load_order = []
    
    begin
      failed = []
      first_name_error = nil
      
      # Attempt to load each file, rescuing which ones raise NameError for
      # undefined constants.  Keep trying to successively reload files that 
      # previously caused NameErrors until they've all been loaded or no new
      # files can be loaded, indicating unresolvable dependencies.
      files.each do |file|
        begin
          require file
          load_order << file
        rescue NameError => ex
          failed << file
          first_name_error ||= ex
        end
      end
      
      # If this pass didn't resolve any NameErrors, we've hit an unresolvable
      # dependency, so raise one of the exceptions we encountered.
      if failed.size == files.size
        raise first_name_error
      else
        files = failed
      end
    end until failed.empty?
    
    load_order
  end
end