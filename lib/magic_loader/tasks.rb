require 'magic_loader'
require 'rake/tasklib'

class MagicLoader::Task < Rake::TaskLib
  def initialize(target, *to_require)
    task :magicload do
      load_order = MagicLoader.require_all *to_require
      p load_order
    end
  end
end