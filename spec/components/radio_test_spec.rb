require 'rails_helper'

describe "Radio", type: :view do
  def component_name
    "radio"
  end

  it "does not render anything if no data is passed" do
    assert_empty render_component({})
  end

  it "throws an error if items are passed but no name is passed" do
    assert_raises do
      render_component(items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        }
      ])
    end
  end

  it "renders radio-group with one item" do
    render_component(
      name: "radio-group-one-item",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        }
      ]
    )

    assert_select ".gem-c-radio__input[name=radio-group-one-item]"
    assert_select ".gem-c-radio:first-child .gem-c-radio__label__text", text: "Use Government Gateway"
  end

  it "renders radio-group with multiple items" do
    render_component(
      name: "radio-group-multiple-items",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        },
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify"
        }
      ]
    )

    assert_select ".gem-c-radio__input[name=radio-group-multiple-items]"
    assert_select ".gem-c-radio:first-child .gem-c-radio__label__text", text: "Use Government Gateway"
    assert_select ".gem-c-radio:last-child .gem-c-radio__label__text", text: "Use GOV.UK Verify"
  end

  it "renders radio-group with bold labels" do
    render_component(
      name: "radio-group-bold-labels",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
          bold: true
        },
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify",
          bold: true
        }
      ]
    )

    assert_select ".gem-c-radio__input[name=radio-group-bold-labels]"
    assert_select ".gem-c-radio .gem-c-label--bold"
  end

  it "renders radio-group with hint text" do
    render_component(
      name: "radio-group-hint-text",
      items: [
        {
          value: "government-gateway",
          hint_text: "You'll have a user ID if you've signed up to do things like sign up Self Assessment tax return online.",
          text: "Use Government Gateway"
        },
        {
          value: "govuk-verify",
          hint_text: "You'll have an account if you've already proved your identity with a certified company, such as the Post Office.",
          text: "Use GOV.UK Verify"
        }
      ]
    )

    assert_select ".gem-c-radio__input[name=radio-group-hint-text]"
    assert_select ".gem-c-radio:first-child .gem-c-radio__label__text", text: "Use Government Gateway"
    assert_select ".gem-c-radio:first-child .gem-c-label__hint", text: "You'll have a user ID if you've signed up to do things like sign up Self Assessment tax return online."
    assert_select ".gem-c-radio:last-child .gem-c-radio__label__text", text: "Use GOV.UK Verify"
    assert_select ".gem-c-radio:last-child .gem-c-label__hint", text: "You'll have an account if you've already proved your identity with a certified company, such as the Post Office."
  end

  it "renders radio-group with checked option" do
    render_component(
      name: "radio-group-checked-option",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        },
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify",
          checked: true
        }
      ]
    )

    assert_select ".gem-c-radio__input[name=radio-group-checked-option]"
    assert_select ".gem-c-radio__input[checked]", value: "govuk-verify"
  end

  it "renders radio-group with custom id prefix" do
    render_component(
      id_prefix: 'custom',
      name: "radio-group-custom-id-prefix",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        },
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify"
        }
      ]
    )

    assert_select ".gem-c-radio__input[name=radio-group-custom-id-prefix]"
    assert_select ".gem-c-radio__input[id=custom-0]", value: "government-gateway"
    assert_select ".gem-c-radio__label__text[for=custom-0]", text: "Use Government Gateway"
    assert_select ".gem-c-radio__input[id=custom-1]", value: "govuk-verify"
    assert_select ".gem-c-radio__label__text[for=custom-1]", text: "Use GOV.UK Verify"
  end

  it "renders radio-group with or divider" do
    render_component(
      name: "radio-group-or-divider",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        },
        :or,
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify"
        }
      ]
    )

    assert_select ".gem-c-radio__input[name=radio-group-or-divider]"
    assert_select ".gem-c-radio:first-child .gem-c-radio__label__text", text: "Use Government Gateway"
    assert_select ".gem-c-radio__block-text", text: "or"
    assert_select ".gem-c-radio:last-child .gem-c-radio__label__text", text: "Use GOV.UK Verify"
  end

  it "renders radio-group with welsh translated 'or'" do
    I18n.with_locale(:cy) do
      render_component(
        name: "radio-welsh-or",
        items: [
          {
            value: "government-gateway",
            text: "Use Government Gateway"
          },
          :or,
          {
            value: "govuk-verify",
            text: "Use GOV.UK Verify"
          }
        ]
      )
    end

    assert_select ".gem-c-radio__block-text", text: "neu"
  end
end

# This component can be interacted with, so use integration tests for these cases.
describe 'Radio (integration)' do
  def input_visible
    false # our inputs are hidden with CSS, and rely on the label.
  end

  it "radio can choose an option" do
    visit '/component-guide/radio/default/preview'

    within '.component-guide-preview' do
      assert_text 'Use GOV.UK Verify'
      assert_text 'Use Government Gateway'

      expect(page).to_not have_selector("[@class='gem-c-radio__input'][@checked='checked']", visible: input_visible)

      page.choose(option: 'govuk-verify', allow_label_click: true)

      expect(page).to_not have_selector("[@class='gem-c-radio__input'][@value='government-gateway'][@checked='checked']", visible: input_visible)
      expect(page).to have_selector("[@class='gem-c-radio__input'][@value='govuk-verify'][@checked='checked']", visible: input_visible)
    end
  end

  it "radio can choose an option when already has one checked" do
    visit '/component-guide/radio/with_checked_option/preview'

    within '.component-guide-preview' do
      assert_text 'Use Government Gateway'
      assert_text 'Use GOV.UK Verify'

      expect(page).to have_selector("[@class='gem-c-radio__input'][@value='govuk-verify'][@checked='checked']", visible: input_visible)
      expect(page).to_not have_selector("[@class='gem-c-radio__input'][@value='government-gateway'][@checked='checked']", visible: input_visible)

      page.choose(option: 'government-gateway', allow_label_click: true)

      expect(page).to have_selector("[@class='gem-c-radio__input'][@value='government-gateway'][@checked='checked']", visible: input_visible)
      expect(page).to_not have_selector("[@class='gem-c-radio__input'][@value='govuk-verify'][@checked='checked']", visible: input_visible)
    end
  end
end
