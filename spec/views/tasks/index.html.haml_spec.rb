require "spec_helper"

describe "tasks/index.html.haml" do
  before do
    assign(:ransack_params, :finished_eq => "1")
    assign(:ransack, Task.ransack({}))
    assign(:tasks, Task.all)
  end
  
  it "displays the correct hints" do
    render
    
    rendered.should include "<span class=\"hint\">Enter a part of the name of the user you are searching for.</span>"
    rendered.should include "Task done"
    rendered.should include "name=\"q[name_cont]\""
    rendered.should include "method=\"get\""
    rendered.should include "<select class=\"select optional\" id=\"task_finished\" name=\"q[finished_eq]\">"
    rendered.should include "<option selected=\"selected\" value=\"1\">Finished</option>"
    rendered.should include "for=\"task_user_user_roles_role\">Customer roles rank</label>"
  end
end
