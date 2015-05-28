class ContactsController < ApplicationController
  layout "verdecircle"

  skip_authorization_check
  before_filter :authenticate_user!, only: [:show]

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    # Index Page
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @contact = Contact.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @return_to = request.env["HTTP_REFERER"] ||= contacts_path
    if user_signed_in? && current_user.is_admin?
      @contact = Contact.find(params[:id])

      respond_to do |format|
        format.html
        format.json { render json: @contact }
      end
    else
      redirect_to @return_to
    end
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        @contact = nil
        flash.now[:success] = "Message successfully sent."
        format.js
      else
        flash.now[:danger] = "#{@contact.errors.count} error(s) prohibited this message from being sent: #{@contact.errors.full_messages.join(', ')}"
        format.js { render :new, status: 200 }
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

  private

    def contact_params
      params.require(:contact).permit(:inquiry, :name, :email, :phone, :subject, :body)
    end

    def not_found
      redirect_to controller: :contacts, action: :index
    end
end
