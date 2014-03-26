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

  def publish
    channel_con = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND channel = 2").first
    @channel_num = "#{channel_con.user_1}_#{channel_con.user_2}"
    @active = params[:active]
    @line_to = params[:line_to]
    @prev = params[:prev]
    @line_width = params[:line_width]
    @line_color = params[:line_color]
    PrivatePub.publish_to("/chat/#{@channel_num}", "")
  end

  def clear
    channel_con = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND channel = 2").first
    @channel_num = "#{channel_con.user_1}_#{channel_con.user_2}"
    if current_user.id == @channel_num.split("_")[0].to_i
      PrivatePub.publish_to("/clear/1", "")
    else
      PrivatePub.publish_to("/clear/2", "")
    end
  end

  def xkcd
    render json: { :url => XKCD.img.split().last() }
  end

  def color
    channel_con = Channel.where("(user_1 = #{current_user.id} OR user_2 = #{current_user.id}) AND channel = 2").first
    @channel_num = "#{channel_con.user_1}_#{channel_con.user_2}"
    if current_user.id == @channel_num.split("_")[0].to_i
      render json: {:color => "#2980b9"}
    else
      render json: {:color => "#1abc9c"}
    end
  end

  def send_img
    data = params[:image]
    image_data = Base64.decode64(data['data:image/png;base64,'.length .. -1])
    File.open("#{Rails.root}/public/uploads/somefilename.png", 'wb') do |f|
      f.write image_data
    end
    #html_stuff = "<h1>Link</h1><p>#{params[:image]}</p>"#"<img src='#{params[:image]}' alt='img'/>"
    binding.pry
    Pony.mail(to: current_user.email, subject: "Sky Song Images!", :headers => { 'Content-Type' => 'text/html' }, :attachments => {"somefilename.png" => File.read("#{Rails.root}/public/uploads/somefilename.png")})
    render json: {:msg => "Success!", :img => html_stuff}
  end

end
