class UsersController < ApplicationController
  before_action :set_user, only: %i[ show liked feed followers following discover ]

  before_action :verify_follow_or_private_status

  before_action :verify_user_is_current_user, only: %i[ feed discover ]
  
  def verify_follow_or_private_status
    unless @user == current_user || @user.private == false || current_user.leaders.find_by( id: @user.id) != nil
      redirect_back fallback_location: root_path, alert: "You need to follow this user first."
    end
  end
  #
  def verify_user_is_current_user
    if @user != current_user
      redirect_back fallback_location: root_path, alert: "You cannot view this user's feed or discover!"
    end
  end

  private

    def set_user
      if params[:username]
        @user = User.find_by!(username: params.fetch(:username))
      else
        @user = current_user
      end
    end
end