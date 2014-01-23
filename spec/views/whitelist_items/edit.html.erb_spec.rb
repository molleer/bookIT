require 'spec_helper'

describe "whitelist_items/edit" do
  before(:each) do
    @whitelist_item = assign(:whitelist_item, stub_model(WhitelistItem,
      :title => "MyString"
    ))
  end

  it "renders the edit whitelist_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", whitelist_item_path(@whitelist_item), "post" do
      assert_select "input#whitelist_item_title[name=?]", "whitelist_item[title]"
    end
  end
end
