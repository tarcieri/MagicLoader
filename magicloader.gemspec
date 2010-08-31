require 'rubygems'

GEMSPEC = Gem::Specification.new do |s|
  s.name = "magicloader"
  s.description = "Painless code dependency management"
  s.summary = <<EOD
Painless code dependency management. Think Bundler, but for managing file load
ordering dependencies.
EOD
  s.version = "0.9.0"
  s.authors = "Tony Arcieri"
  s.email = "bascule@gmail.com"
  s.homepage = "http://github.com/tarcieri/MagicLoader"
  s.date = Time.now
  s.platform = Gem::Platform::RUBY

  # Gem contents
  s.files = Dir.glob("{lib,spec}/**/*") + ['Rakefile', 'magicloader.gemspec']

  # RDoc settings
  s.has_rdoc = true
  s.rdoc_options = %w(--title MagicLoader --main README.markdown --line-numbers)
  s.extra_rdoc_files = ["LICENSE", "README.markdown", "CHANGES"]
end
