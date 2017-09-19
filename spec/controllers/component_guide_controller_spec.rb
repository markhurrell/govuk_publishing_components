require "spec_helper"

describe GovukPublishingComponents::ComponentGuideController, type: :controller do
  describe "index" do
    it "renders the index template" do
      get '/component-guide'
      expect(response).to render_template("index")
    end
  end
end
