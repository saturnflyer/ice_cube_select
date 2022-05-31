class SamplesController < ApplicationController

  def index
  end

  def create
    @fake_model = params[:fake_model]
  end
end
