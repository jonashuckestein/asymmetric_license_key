Gem::Specification.new do |s|
  s.name        = "asymmetric_license_key"
  s.version     = "0.0.0"
  s.date        = "2014-03-06"
  s.summary     = "Generate license keys"
  s.description = "Generate license codes for use in software activation." +
                  "Use the asymmetric DSA algorithm to protect against " +
                  "keygens (and for fun!)"
  s.authors     = ["Jonas Huckestein"]
  s.email       = "jonas.huckestein@gmail.com"
  s.files       = ["lib/asymmetric_license_key.rb"]
  s.homepage    =
    "http://github.com/jonashuckestein/asymmetric_license_key"
  s.license       = "MIT"
end
