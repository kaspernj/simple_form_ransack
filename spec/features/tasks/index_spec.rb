require "spec_helper"

describe "tasks_index" do
  before do
    visit tasks_path(q:  {finished_eq: "1", user_country_eq: "DK"})

    expect(page).to have_http_status(:success)
    expect(current_path).to eq tasks_path
  end

  it "displays the correct hints" do
    expect(page.html).to include "<span class=\"hint\">Enter a part of the name of the user you are searching for.</span>"
    expect(page.html).to include "Task done"
    expect(page.html).to include "name=\"q[name_cont]\""
    expect(page.html).to include "method=\"get\""
    expect(page.html).to include "<option selected=\"selected\" value=\"1\">Finished</option>"
  end

  it "handels countries correctly" do
    country_select = find("#q_user_country_eq")
    expect(country_select["name"]).to eq "q[user_country_eq]"

    denmark_option = find("#q_user_country_eq option[value='DK']")
    expect(denmark_option["selected"]).to eq "selected"
  end

  it "handles sub models correctly" do
    label = find("label[for=q_user_user_roles_role_eq]")
    expect(label.text).to eq "Customer roles rank"
  end

  it "handels collections and selects correctly" do
    task_finished = find("#q_finished_eq")
    expect(task_finished["class"]).to eq "select optional"
    expect(task_finished["name"]).to eq "q[finished_eq]"

    finished_option = find("#q_finished_eq option[value='1']")

    expect(finished_option["selected"]).to eq "selected"
  end

  it "allows custom inputs to be defined" do
    input = find("#q_custom_input")
    expect(input["class"]).to eq "string optional"
    expect(input["name"]).to eq "q[custom_input]"
    expect(input["type"]).to eq "text"
    expect(input["value"]).to eq ""
  end

  it "groups by _or_" do
    label = find("label[for='q_user_email_or_name_cont']")
    find("#q_user_email_or_name_cont")

    expect(label.text).to eq "Customer email, name contains"
  end
end
