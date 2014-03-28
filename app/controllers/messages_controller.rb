class MessagesController < ApplicationController
  before_action :authenticate_user!
  def index
    @messages = Message.all
    channel_con = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND channel = 2").first
    if channel_con != nil
      @channel_num = "#{channel_con.user_1}_#{channel_con.user_2}"
    end
  end

  def create
    @message = Message.create!(content: params[:content])
    channel_con = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND channel = 2").first
    @channel_num = "#{channel_con.user_1}_#{channel_con.user_2}"
    PrivatePub.publish_to("/messages/#{@channel_num}", message: @message)
  end
end
