MagicLoader
===========

A wonderfully simple way to load your code.

Tired of futzing around with require statements everywhere, littering your code
with <code>require File.dirname(__FILE__)</code> crap?  What if you could just 
point something at a big directory full of code and have everything just 
automagically load regardless of the dependency structure?  

Wouldn't that be nice?  Well, now you can!

 <code>require 'magic_loader_'</code>

You can use MagicLoader in a multitude of different ways.

The easiest way to use require_all is to just point it at a directory
containing a bunch of .rb files:

 <code>MagicLoader.require_all 'lib'</code>

This will find all the .rb files under the lib directory (including all 
subdirectories as well) and load them.

The proper order to in which to load them is determined automatically.  If the 
dependencies between the matched files are unresolvable, it will throw the 
first unresolvable NameError.

You can also give it a glob, which will enumerate all the matching files: 

 <code>MagicLoader.require_all 'lib/**/*.rb'</code>

It will also accept an array of files:

 <code>MagicLoader.require_all Dir.glob("blah/**/*.rb").reject { |f| stupid_file? f }</code>
 
Or if you want, just list the files directly as arguments:

 <code>MagicLoader.require_all 'lib/a.rb', 'lib/b.rb', 'lib/c.rb', 'lib/d.rb'</code>

So what's the magic?
--------------------

MagicLoader is just a Ruby library, after all. There's no magic but what you
don't understand.  I didn't invent the approach this gem uses.  It was 
shamelessly stolen from Merb (which apparently stole it from elsewhere).

Here's how it works:  

* Enumerate the files to be loaded
* Try to load all of the files.  If we encounter a NameError loading a 
  particular file, store that file in a "try to load it later" list.
* If all the files loaded, great, we're done!  If not, go through the
  "try to load it later" list again rescuing NameErrors the same way.
* If we walk the whole "try to load it later" list and it doesn't shrink
  at all, we've encountered an unresolvable dependency.  In this case,
  require_all will rethrow the first NameError it encountered.

Questions? Comments? Concerns?
------------------------------

You can reach the author on github or freenode: "tarcieri"

Or by email: [tony@medioh.com](mailto:tony@medioh.com)

Got issues with require_all to report?  Post 'em here:

[Github Tracker](http://github.com/tarcieri/require_all/issues)

License
-------

MIT (see the LICENSE file for details)
