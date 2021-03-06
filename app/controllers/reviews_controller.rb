class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :only => [:edit, :destroy, :update] do
    if not current_user && current_user.admin
      redirect_to new_user_session_path
      flash[:alert] = "Unauthorized. Log in with credentials authorized for attempted action to proceed."
    end
  end
  
    def new
      @product = Product.find(params[:product_id])
      @review = @product.reviews.new
      render :new
    end

    def create
      @product = Product.find(params[:product_id])
      @review = @product.reviews.new(review_params)
      if @review.save
        flash[:notice] = "Review successfully added!"
        redirect_to product_path(@product)
      else
        flash[:alert] = "Error detected - review not created. Please try again."
        render :new
      end
    end
    
    def show
      @product = Product.find(params[:product_id])
      @review = Review.find(params[:id])
      render :show
    end
    
    def edit
      @product = Product.find(params[:product_id])
      @review = Review.find(params[:id])
      render :edit
    end
    
    def update
      @review = Review.find(params[:id])
      if @review.update(review_params)
        flash[:notice] = "Review successfully added!"
        redirect_to product_path(@review.product)
      else
        flash[:alert] = "Error detected - review not updated. Please try again."
        @product = Product.find(params[:product_id])
        render :edit
      end
    end

    def destroy
      @review = Review.find(params[:id])
      if @review.destroy
        flash[:notice] = "Review successfully deleted!"
        redirect_to product_path(@review.product)
      end
    end
  
    private
      def review_params
        params.require(:review).permit(:author, :rating, :content_body)
      end
  end