class Channel < ActiveRecord::Base
  def self.send_image(data_1, data_2, current_user)
    image_data_1 = Base64.decode64(data_1['data:image/png;base64,'.length .. -1])
    image_data_2 = Base64.decode64(data_2['data:image/png;base64,'.length .. -1])
    File.open("#{Rails.root}/public/uploads/image_1.png", 'wb') do |f|
      f.write image_data_1
    end
    File.open("#{Rails.root}/public/uploads/image_2.png", 'wb') do |f|
      f.write image_data_2
    end
    @email = current_user.email
    Notifier.send_image(@email).deliver
  end
end
