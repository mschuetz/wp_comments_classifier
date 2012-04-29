Gem::Specification.new do |s|
  s.name        = 'wp_comments_classifier'
  s.version     = '0.0.1'
  s.date        = '2012-04-29'
  s.summary     = 'A comment classifier for Wordpress blogs.'
  s.description = 'Classifies comments in a wordpress database based on previous classifications using naive bayes.'
  s.authors     = ['Matthias Schütz']
  s.email       = 'mschuetz@gmail.com'
  s.files       = ['lib/naivebayes.rb', 'lib/wp_comment_classifier.rb']
  s.homepage    = 'https://github.com/mschuetz/wp_comments_classifier'
  s.executables << 'bin/classify_wp_comments'
  s.add_runtime_dependency('rdbi', [">= 0.9.1"])
end