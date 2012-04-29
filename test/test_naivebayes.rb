require 'wp_comments_classifier/naivebayes'
require 'minitest/spec'
require 'minitest/autorun'

describe NaiveBayes do
  before do
      training = {
        :spam=>["offer is secret", "click secret link", "secret sports link"],
        :ham=>["play sports today", "went play sports", "secret sports event", "sports is today", "sports costs money"]
      }
      @classifier = NaiveBayes::Classifier.new(training)
  end

  describe "when asked about 'secret links'" do
    it "should say it's spam" do
      classifications = @classifier.classify("i have a secret link for you")
      classifications.must_be_kind_of Hash
      NaiveBayes::Util.highest_ranking(classifications).must_equal :spam
    end
  end

  describe "when asked about 'would you like to go to the sports event today'" do
    it "should say it's ham" do
      classifications = @classifier.classify('would you like to go to the sports event today')
      classifications.must_be_kind_of Hash
      NaiveBayes::Util.highest_ranking(classifications).must_equal :ham
    end
  end
  
=begin
  describe "when asked about nil" do
    it "should raise an ArgumentError" do
      classifications = @classifier.classify(nil)
    end
  end
=end
end
