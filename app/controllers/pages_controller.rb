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
    msg = {}
    if current_user.check != 1 && current_user.check != 2
      channel = Channel.where("channel = 1")
      if channel == []
        channel_con = Channel.create(user_1: current_user.id, channel: 1)
        current_user.check = 1
        msg = {"msg" => "waiting...", "channel" => channel_con.channel}
      else
        channel_con = channel.first
        channel_con.channel = 2
        channel_con.user_2 = current_user.id
        current_user.check = 2
        channel_con.save!
        msg = {"msg" => "Connected!", "channel" => channel_con.channel}
      end
      current_user.save!
    end
    render :json => msg
  end

  def check_connect
    channel_con = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND channel = 2")
    if channel_con == []
      render json: {"msg" => "Disconnected!"}
    else
      render json: {"msg" => "Connected!"}
    end
  end

  def clear_session
    current_user.check = 0
    current_user.save!
    channel_con = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND (channel = 2 OR channel = 1)")
    if channel_con == []
      render json: {"msg" => "no current"}
    else
      channel = channel_con.first
      channel.channel = 0
      channel.save!
      render json: {"msg" => 'cleared!'}
    end
  end

end
