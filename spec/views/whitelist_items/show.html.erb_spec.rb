require 'spec_helper'

describe "whitelist_items/show" do
  before(:each) do
    @whitelist_item = assign(:whitelist_item, stub_model(WhitelistItem,
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
  end
end
