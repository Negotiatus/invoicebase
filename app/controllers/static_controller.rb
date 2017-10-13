class StaticController < ApplicationController
  def home
    if user_signed_in?
      redirect_to #somewhere
    end
  end
end
