require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(sUserID: "test", password: "test", password_confirmation: "test")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "password should be present (nonblank)" do
      @user.password = @user.password_confirmation = " "
      assert_not @user.valid?
    end
end