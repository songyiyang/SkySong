class InfoController < ApplicationController
  def main
    if current_user
      redirect_to '/main'
    end
  end
end
