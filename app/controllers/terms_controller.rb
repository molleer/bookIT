class TermsController < ApplicationController
  before_action :set_term, only: [:edit, :update, :destroy]
  authorize_resource

  # GET /terms
  # GET /terms.json
  def index
    @terms = Term.all
  end

  # GET /terms/1/edit
  def edit
  end

  # PATCH/PUT /terms/1
  # PATCH/PUT /terms/1.json
  def update
    respond_to do |format|
      if @term.update(term_params)
        format.html { redirect_to terms_path, notice: 'Term was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @term.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_term
      @term = Term.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def term_params
      params.require(:term).permit(:title, :content, :active)
    end
end
