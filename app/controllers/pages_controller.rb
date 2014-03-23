class PagesController < ApplicationController
  before_action :authenticate_user!
  def main_page
  end
  def disconnect
    msg = {"msg" => "success"}
    channel = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND channel = 2").first
    channel.channel = 0
    first_user = User.find(channel.user_1)
    second_user = User.find(channel.user_2)
    first_user.check = 0
    second_user.check = 0
    first_user.save!
    second_user.save!
    channel.save!
    render json: msg
  end

  def connect
    if current_user.check != 1 && current_user.check != 2
      channel = Channel.where("channel = 1")
      if channel == []
        channel_con = Channel.create(user_1: current_user.id, channel: 1)
        current_user.check = 1
        #puts some javascript to waiting
      else
        channel_con = channel.first
        channel_con.channel = 2
        channel_con.user_2 = current_user.id
        current_user.check = 2
        channel_con.save!
      end
      current_user.save!
    end
    msg = {"msg" => "success", "channel" => channel_con.channel}
    render :json => msg
  end

  def check_connect
    channel_con = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND channel = 2")
    if channel_con == []
      render json: {"channel" => 0}
    else
      render json: {"channel" => 2}
    end
  end
end
