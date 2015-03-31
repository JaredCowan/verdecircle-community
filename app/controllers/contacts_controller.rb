class ContactsController < ApplicationController
  layout "verdecircle"

  skip_authorization_check
  before_filter :authenticate_user!, only: [:show]

  def index
    # Index Page
    respond_to do |format|
      format.html
    end
  end

  # For admins to view all submits
  def submits
    if user_signed_in? && current_user.is_admin?
      @contacts = Contact.all
      respond_to do |format|
        format.html
        format.json { render json: @contact }
      end
    else
      redirect_to controller: "contacts", action: "index"
    end
  end

  def new
    @contact = Contact.new

    respond_to do |format|
      format.html { redirect_to controller: "contacts", action: "index" }
    end
  end

  def show
    if user_signed_in? && current_user.is_admin?
      @contact = Contact.find(params[:id])

      respond_to do |format|
        format.html
        format.json { render json: @contact }
      end
    else
      redirect_to controller: "contacts", action: "index"
    end
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to controller: "contacts", action: "index"  }
        flash.now[:success] = "Message successfully sent."
      else
        format.html { redirect_to controller: "contacts", action: "index" }
        flash.now[:danger] = "#{@contact.errors.count} error(s) prohibited this message from being sent: #{@contact.errors.full_messages.join(', ')}"
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.destroy
        format.html { render :index }
        flash.now[:success] = "Message was successfully deleted."
      else
        flash.now[:success] = "There was an error deleting this message."
        render :back
      end
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:inquiry, :name, :email, :phone, :subject, :body)
    end
end
