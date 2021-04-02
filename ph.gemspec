# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name              = "ph"
  s.version           = "0.1.0"
  s.summary           = "Perceptual Hashing"
  s.authors           = ["elcuervo"]
  s.licenses          = %w[MIT]
  s.email             = ["elcuervo@elcuervo.net"]
  s.homepage          = "http://github.com/elcuervo/ph"
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files test`.split("\n")

  s.add_development_dependency("vips", "~> 8.10")
end
