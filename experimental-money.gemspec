Gem::Specification.new do |s|
  s.name              = "experimental-money"
  s.version           = "0.0.1"
  s.summary           = "Money arithmetic with BigDecimal"
  s.description       = "Money arithmetic with BigDecimal"
  s.authors           = ["CarlosIPe"]
  s.email             = ["carlos2@compendium.com.ar"]
  s.homepage          = "https://github.com/carlosipe/experimental-money"
  s.license           = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency "cutest", '~> 1'
end
