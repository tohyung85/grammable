class GramsController < ApplicationController
  def index
    
  end

  def new
    @gram = Gram.new
  end

  def create
    @gram = Gram.create(gram_params)
    if @gram.present?
      redirect_to root_path  
    end
  end

  private

  def gram_params
    params.require(:gram).permit(:message) 
  end


end
