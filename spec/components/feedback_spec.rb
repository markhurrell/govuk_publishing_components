require 'rails_helper'

describe "Feedback", type: :view do
  def component_name
    "feedback"
  end

  it "asks the user if the page is useful without javascript enabled" do
    render_component({})

    assert_select ".gem-c-feedback .gem-c-feedback__prompt-link--useful[href='/contact/govuk']", text: 'Yes this page is useful'
    assert_select ".gem-c-feedback .gem-c-feedback__prompt-link.js-page-is-not-useful[href='/contact/govuk']", text: 'No this page is not useful'
  end

  it "asks the user if there is anything wrong with the page without javascript enabled" do
    render_component({})

    assert_select ".gem-c-feedback .gem-c-feedback__prompt-link--wrong[href='/contact/govuk']", text: 'Is there anything wrong with this page?'
  end

  it "removes top margin when margin_top flag is set" do
    render_component(margin_top: 0)

    assert_select ".gem-c-feedback.gem-c-feedback--margin-top", false
  end
end
