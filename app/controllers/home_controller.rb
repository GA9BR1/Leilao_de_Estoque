class HomeController < ApplicationController
  def index
    @batches = Batch.where('end_date >= ? AND approved_by_id IS NOT NULL', Date.today)
  end
end