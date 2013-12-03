describe UserMailer do
  describe "Comment email" do
    CATEGORY = 'Comment'
    CONTENT = 'This is a comment'
    
    let(:msg) { UserMailer.comment_email(CATEGORY, CONTENT) }

    it "should return a message object" do
      msg.should_not be_nil
    end
  
    it "should have the right sender" do
      msg.from.to_s.should match(ApplicationHelper::MAILER_FROM_ADDRESS)
    end
    
    describe "Send the message" do
      before { msg.deliver }
        
      it "should get queued" do
        ActionMailer::Base.deliveries.should_not be_empty
        ActionMailer::Base.deliveries.count.should == 1
      end
      # msg.to is a Mail::AddressContainer object, not a string
      # Even then, converting to a string gives you ["<address>"], so match captures the intent easier
      it "should be sent to administrators" do
        ApplicationHelper::HUDACARD_ADMIN.each do |admin|
          msg.to.to_s.should match(admin)
        end
      end
      
      it "should have the right subject" do
        msg.subject.should match(CATEGORY)
      end
      
      it "should have the right content" do
        msg.body.encoded.should match(CONTENT)
        
        ActionMailer::Base.deliveries.count.should == 1
      end
    end
  end
end
