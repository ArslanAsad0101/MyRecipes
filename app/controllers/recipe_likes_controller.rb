class RecipeLikesController < ApplicationController
  before_action :set_recipe

  def create
    like = @recipe.recipe_likes.new(like_owner_params)

    if like.save
      render json: { likes_count: @recipe.reload.likes_count }, status: :created
    else
      render json: { error: like.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end

  def like_owner_params
    if chef_signed_in?
      { chef: current_chef }
    else
      { visitor_token: visitor_token }
    end
  end

  def visitor_token
    cookies.permanent.signed[:visitor_token] ||= SecureRandom.uuid
  end
end
