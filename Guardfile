# We have a small test suite and always run all tests
guard :minitest, all_on_start: true, include: %w{lib} do
  watch(%r{^test/(.*)\/?(.*)_test\.rb$}) { "test" }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { "test" }
  watch(%r{^test/test_helper\.rb$}) { "test" }
end
