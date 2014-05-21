require "spec_helper"

describe TasksController do
  context "hints" do
    render_views
    
    it "shows hints" do
      get :index, :q => {:finished_eq => "1"}
      body = response.body
      body.should include "<span class=\"hint\">Enter a part of the name of the user you are searching for.</span>"
      body.should include "name=\"q[name_cont]\""
      body.should include "method=\"get\""
      body.should include "<select class=\"select optional\" id=\"task_finished\" name=\"q[finished_eq]\">"
      body.should include "<option selected=\"selected\" value=\"1\">Finished</option>"
      
      # puts "Body: #{body}"
    end
  end
end
