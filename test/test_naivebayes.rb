require 'test_helper'

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
  
begin
  describe "when asked about classifications whose probabilities are all within epsilon" do
    it "should return unclassified" do
      klass = NaiveBayes::Util.highest_ranking({spam: 0.51, ham: 0.49}, 0.05)
      klass.must_equal NaiveBayes::Util::Unclassified

      klass = NaiveBayes::Util.highest_ranking({spam: 0.0, ham: 0.0})
      klass.must_equal NaiveBayes::Util::Unclassified
    end
  end
end
end
