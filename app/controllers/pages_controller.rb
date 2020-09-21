class PagesController < ApplicationController

  def homepage
    load_global_stats
  end

end
