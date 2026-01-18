class SamplesController < ApplicationController
  def index
  end

  def create
    @fake_model = params[:sample]
  end
end
