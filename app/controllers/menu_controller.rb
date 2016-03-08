class MenuController < ApplicationController

  def create
    @file = params[:attachment]
    unless @file.nil?
      p "hello, create"
    end
  end

end
