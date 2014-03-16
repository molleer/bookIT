class WhitelistItemsController < ApplicationController
  before_action :set_whitelist_item, only: [:show, :edit, :update, :destroy]

  # GET /whitelist_items
  # GET /whitelist_items.json
  def index
    @whitelist_items = WhitelistItem.active
  end

  # GET /whitelist_items/1
  # GET /whitelist_items/1.json
  def show
  end

  # GET /whitelist_items/new
  def new
    @whitelist_item = WhitelistItem.new
  end

  # GET /whitelist_items/1/edit
  def edit
  end

  # POST /whitelist_items
  # POST /whitelist_items.json
  def create
    @whitelist_item = WhitelistItem.new(whitelist_item_params)

    respond_to do |format|
      if @whitelist_item.save
        format.html { redirect_to @whitelist_item, notice: 'Whitelist item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @whitelist_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @whitelist_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /whitelist_items/1
  # PATCH/PUT /whitelist_items/1.json
  def update
    respond_to do |format|
      if @whitelist_item.update(whitelist_item_params)
        format.html { redirect_to @whitelist_item, notice: 'Whitelist item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @whitelist_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /whitelist_items/1
  # DELETE /whitelist_items/1.json
  def destroy
    @whitelist_item.destroy
    respond_to do |format|
      format.html { redirect_to whitelist_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_whitelist_item
      @whitelist_item = WhitelistItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def whitelist_item_params
      params.require(:whitelist_item).permit(:title, :rule_start, :rule_end, :blacklist, :begin_time, :end_time, day_array: [ :'0', :'1', :'2', :'3', :'4', :'5', :'6'])
    end
end
