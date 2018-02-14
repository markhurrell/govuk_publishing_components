require "spec_helper"

describe 'Static’s component guide' do
  before(:all) do
    GovukPublishingComponents.configure { |config| config.static = true }
  end

  after(:all) do
    GovukPublishingComponents.configure { |config| config.static = false }
  end

  it 'loads a static (shared) component with correct component directory' do
    visit '/component-guide/test-static-component'

    expect(body).to include('<span class="n">render</span> <span class="s2">"govuk_component/test-static-component"</span>')
    within '.component-guide-preview', match: :first do
      expect(page).to have_selector('.a-test-static-component')
    end
  end

  it 'loads shared components locally rather than through the network using Slimmer’s local component resolver' do
    visit '/component-guide'

    expect(page).to have_selector('.stubbed-breadcrumbs-component')
    expect(page).to have_selector('.stubbed-title-component')
  end
end
