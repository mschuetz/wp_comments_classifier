require 'wp_comments_classifier/naivebayes'

module WordpressUtils
  module ApprovalStatus
    SPAM = 'spam'
    HAM = '1'
    NONE = '0'
  end

  class CommentsClassifier
    
    attr_accessor :debug

    def initialize(dbh)
      @dbh = dbh
      @my = nil
      @classifier = nil
    end

    def learn
      training_set = {}
      [ApprovalStatus::SPAM, ApprovalStatus::HAM].each do |approval|
        messages = []
        content(approval){|id, msg| messages << msg if (msg && !msg.empty?) }
        training_set[approval] = messages
      end
      STDERR.puts "training set = #{training_set}" if debug
      @classifier = NaiveBayes::Classifier.new(training_set)
    end
    
    def classify_unapproved
      @dbh.prepare('update wp_comments set comment_approved=? where comment_ID=?') do |stmt|
        content(ApprovalStatus::NONE) do |id, content|
          next if content.nil?
          classes = @classifier.classify(content)
          STDERR.puts "classifications=#{classes}" if debug
          classification = NaiveBayes::Util.highest_ranking(classes)
          yield id, content, classification if block_given?
          STDERR.puts "id=#{id} classification=#{classification} content=#{content}" if debug
          stmt.execute(classification, id) if classification != NaiveBayes::Util::Unclassified
        end
      end
    end

    def content(approval_status)
      stmt = @dbh.prepare("select comment_ID, comment_content from wp_comments where comment_approved=?")
      stmt.execute(approval_status).each {|id, content| yield id, content}
    end
  end
end