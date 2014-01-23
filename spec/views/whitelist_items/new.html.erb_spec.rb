require 'spec_helper'

describe "whitelist_items/new" do
  before(:each) do
    assign(:whitelist_item, stub_model(WhitelistItem,
      :title => "MyString"
    ).as_new_record)
  end

  it "renders new whitelist_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", whitelist_items_path, "post" do
      assert_select "input#whitelist_item_title[name=?]", "whitelist_item[title]"
    end
  end
end
