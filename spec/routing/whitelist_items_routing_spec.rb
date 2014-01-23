require "spec_helper"

describe WhitelistItemsController do
  describe "routing" do

    it "routes to #index" do
      get("/whitelist_items").should route_to("whitelist_items#index")
    end

    it "routes to #new" do
      get("/whitelist_items/new").should route_to("whitelist_items#new")
    end

    it "routes to #show" do
      get("/whitelist_items/1").should route_to("whitelist_items#show", :id => "1")
    end

    it "routes to #edit" do
      get("/whitelist_items/1/edit").should route_to("whitelist_items#edit", :id => "1")
    end

    it "routes to #create" do
      post("/whitelist_items").should route_to("whitelist_items#create")
    end

    it "routes to #update" do
      put("/whitelist_items/1").should route_to("whitelist_items#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/whitelist_items/1").should route_to("whitelist_items#destroy", :id => "1")
    end

  end
end
