require 'spec_helper'

describe Micropost do
  
  before(:each) do 
      @user = Factory(:user)
      @attr = { :content => "value for content" }
      # :user_id => 1   --Invalid because it assigns the user id through mass assignment
      #                 --which is what attr_accessible is designed to prevent (in micropost model)
  end
  
  it "should create a new instance given valid attributes" do
    # Micropost.create!(@attr)     --Goes with the invalid user_id assignment
    @user.microposts.create!(@attr)
  end  
  
  describe "user associations" do
    
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    
    it "should have a user attribute" do 
      @micropost.should respond_to(:user)
    end
    
    it "should have the right associated user" do 
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end
  
  describe "micropost associations" do
    
    before(:each) do
      @user = User.create(@attr)
    end
    
    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end
  end
  
  describe "validations" do
    
    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end
    
    it "should reject long content" do
      @user.microposts.build(:content => "a" *141).should_not be_valid
    end
  end
end
