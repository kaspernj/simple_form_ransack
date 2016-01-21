require "spec_helper"

describe TasksController do
  context "hints" do
    render_views

    it "should not fail" do
      get :index, q: {finished_eq: "1"}
      response.body.should_not eq nil
    end
  end
end
