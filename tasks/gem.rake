require 'rake/gempackagetask'
load File.expand_path('../../magicloader.gemspec', __FILE__)

Rake::GemPackageTask.new(GEMSPEC) do |pkg|
  pkg.need_tar = true
end