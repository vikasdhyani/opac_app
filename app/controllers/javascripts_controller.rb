class JavascriptsController < ApplicationController
  caches_page :path_helpers

  def path_helpers
    render :template => "javascripts/path_helpers.js.erb"
  end
end