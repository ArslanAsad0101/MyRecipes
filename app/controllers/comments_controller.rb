class CommentsController < ApplicationController
  before_action :require_chef!
  before_action :set_recipe

  def create
    @comment = @recipe.comments.new(comment_params.merge(chef: current_chef))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to recipe_path(@recipe), notice: "Comment posted successfully." }
        format.turbo_stream
      else
        format.html do
          @comments = @recipe.comments.includes(:chef).order(created_at: :desc)
          render "welcome/show", status: :unprocessable_entity
        end
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { recipe: @recipe, comment: @comment })
        end
      end
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
