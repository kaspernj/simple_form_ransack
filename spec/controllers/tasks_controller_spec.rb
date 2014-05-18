require "spec_helper"

describe TasksController do
  context "hints" do
    render_views
    
    it "shows hints" do
      get :index
      body = response.body
      body.should include "<span class=\"hint\">Enter a part of the name of the user you are searching for.</span>"
      body.should include "name=\"q[name_cont]\""
    end
  end
end
