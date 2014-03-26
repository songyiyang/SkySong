class Notifier < ActionMailer::Base
  default from: "DONOTREPLY@skysong.com"
  def send_image(email)
    attachments["image_1.png"] = File.read("#{Rails.root}/public/uploads/image_1.png")
    attachments["image_2.png"] = File.read("#{Rails.root}/public/uploads/image_2.png")
    mail(to: email, subject: "Sky Song : Your Drawings!")
  end
end
