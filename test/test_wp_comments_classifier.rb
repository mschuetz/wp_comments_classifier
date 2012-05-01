require 'test_helper'

describe WordpressUtils::CommentsClassifier do
  before do
    training = {
      :spam=>["offer is secret", "click secret link", "secret sports link"],
      :ham=>["play sports today", "went play sports", "secret sports event", "sports is today", "sports costs money"]
    }
    @dbh = RDBI.connect(:SQLite3, :database => ":memory:")
    
    @dbh.execute('create table wp_comments (comment_ID integer, comment_content varchar(255), comment_approved varchar(10))')
    id = 0
    training[:spam].each do |msg|
      @dbh.prepare('insert into wp_comments (comment_ID, comment_content, comment_approved) values (?, ?, \'spam\')') do |stmt|
        stmt.execute(id+=1, msg)
      end
    end
    training[:ham].each do |msg|
      @dbh.prepare('insert into wp_comments (comment_ID, comment_content, comment_approved) values (?, ?, 1)') do |stmt|
        stmt.execute(id+=1, msg)
      end
    end
    
    @classifier = WordpressUtils::CommentsClassifier.new(@dbh)
    #@classifier.debug = true
    @classifier.learn
  end
  
  def approval_status_of(id)
    @dbh.execute("select comment_approved from wp_comments where comment_ID=#{id}").fetch(:first)[0]
  end

  describe "when asked about 'secret links'" do
    it "should say it's spam" do
      @dbh.execute('insert into wp_comments (comment_ID, comment_content, comment_approved) values (30, \'i have a secret link for you\', 0)')
      @classifier.classify_unapproved {|id, content, approval_status|
        approval_status.must_equal WordpressUtils::ApprovalStatus::SPAM
      }
      approval_status_of(30).must_equal WordpressUtils::ApprovalStatus::SPAM
    end
  end

  describe "when asked about 'would you like to go to the sports event today'" do
    it "should say it's ham" do
      @dbh.execute('insert into wp_comments (comment_ID, comment_content, comment_approved) values (31, \'would you like to go to a sports event today\', 0)')
      @classifier.classify_unapproved {|id, content, approval_status|
        approval_status.must_equal WordpressUtils::ApprovalStatus::HAM
      }
      approval_status_of(31).must_equal WordpressUtils::ApprovalStatus::HAM
    end
  end
end
