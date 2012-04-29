LIB_DIR = 'lib/wp_comments_classifier'
Gem::Specification.new do |s|
  s.name        = 'wp_comments_classifier'
  s.version     = '0.0.1.pre'
  s.date        = '2012-04-29'
  s.summary     = 'A comment classifier for Wordpress blogs.'
  s.description = 'Classifies comments in a wordpress database based on previous classifications using naive bayes.'
  s.authors     = ['Matthias Schütz']
  s.email       = 'mschuetz@gmail.com'
  s.files       = [LIB_DIR + '/naivebayes.rb', LIB_DIR + '/database_classifier.rb']
  s.homepage    = 'https://github.com/mschuetz/wp_comments_classifier'
  s.executables << 'classify_wp_comments'
  s.add_runtime_dependency('rdbi', [">= 0.9.1"])
  s.add_runtime_dependency('json', [">= 1.7.0"])
  s.add_development_dependency('simplecov', [">= 0.6.2"])
end