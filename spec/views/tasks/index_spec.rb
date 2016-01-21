require "spec_helper"

describe "tasks/index.html.haml" do
  before do
    assign(:ransack_params, finished_eq: "1", user_country_eq: "DK")
    assign(:ransack, Task.ransack({}))
    assign(:tasks, Task.all)

    render

    # puts "Rendered: #{rendered}"
  end

  it "displays the correct hints" do
    expect(rendered).to include "<span class=\"hint\">Enter a part of the name of the user you are searching for.</span>"
    expect(rendered).to include "Task done"
    expect(rendered).to include "name=\"q[name_cont]\""
    expect(rendered).to include "method=\"get\""
    expect(rendered).to include "<select class=\"select optional\" id=\"task_finished\" name=\"q[finished_eq]\">"
    expect(rendered).to include "<option selected=\"selected\" value=\"1\">Finished</option>"
    expect(rendered).to include "for=\"task_user_user_roles_role\">Customer roles rank</label>"
    expect(rendered).to include "<option selected=\"selected\" value=\"DK\">Denmark</option>"
  end

  it "allows custom inputs to be defined" do
    expect(rendered).to include "<input class=\"string optional\" id=\"task_custom_input\" name=\"q[custom_input]\" type=\"text\" value=\"\" />"
  end

  it "groups by _or_" do
    expect(rendered).to include "user_email_or_name_cont"
    expect(rendered).to include "for=\"task_user_email_or_name\">Customer email, name contains</label>"
  end
end
