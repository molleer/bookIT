require 'spec_helper'

describe "whitelist_items/index" do
  before(:each) do
    assign(:whitelist_items, [
      stub_model(WhitelistItem,
        :title => "Title"
      ),
      stub_model(WhitelistItem,
        :title => "Title"
      )
    ])
  end

  it "renders a list of whitelist_items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
