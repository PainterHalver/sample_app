class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action ->{load_user_by_id params[:followed_id]}, only: :create
  before_action ->{load_relationship_by_id params[:id]}, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_user_by_id id
    @user = User.find_by(id:)
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def load_relationship_by_id id
    @relationship = Relationship.find_by(id:)
    return if @relationship

    flash[:danger] = t "relationship_not_found"
    redirect_to root_path
  end
end
