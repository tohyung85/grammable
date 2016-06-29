class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @gram = Gram.find_by_id(params[:gram_id])
    if @gram.blank?
      return render_not_found
    end
    @gram.comments.create(comment_params.merge(user: current_user))
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

  def render_not_found(status=:not_found)
    render text: '#{status.to_s.titleize}', status: status
  end

end