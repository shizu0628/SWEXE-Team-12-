class SpotsController < ApplicationController
  def index
    @spots = Spot.order(:id)
  end

  def show
    @spot = Spot.find(params[:id])
  end
end