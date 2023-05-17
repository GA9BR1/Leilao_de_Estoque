class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @doubt = Doubt.find(params[:doubt_id])
    @batch = Batch.find(params[:batch_id])
    @answer = @doubt.answers.new
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user

    if @answer.valid?
      if @answer.user.admin == true
        @answer.doubt.answered = true
        @answer.doubt.save!
      else
        @answer.doubt.answered = false
        @answer.doubt.save!
      end
      @answer.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @answer.doubt }
      end
    else
      
    end
  end

  def answer_params
    params.require(:answer).permit(:content, :doubt_id)
  end
end