class ConversationsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  helper_method :mailbox, :conversation
  respond_to :html, :json

  def index
    @inbox ||= current_user.mailbox.inbox

    respond_to do |format|
      format.html
      format.json { render json: @inbox, include: [:recipients, :receipts, :messages] }
    end
  end

  def create
    recipient_emails = conversation_params(:recipients).split(',')
    recipients = User.where(email: recipient_emails).all
    conversation = current_user.
      send_message(recipients, *conversation_params(:body, :subject)).conversation

    flash.keep[:success] = "Your message has been sent to: #{recipients.all.map(&:username).map { |u| u.titleize }.join(',\s')
}."
    # data = {userdata: current_user.username}
    # Pusher['notifications'].trigger('message', data)
    redirect_to :conversations
  end

  def reply
    current_user.reply_to_conversation(conversation, *message_params(:body))
    conversation.mark_as_read(current_user)
    redirect_to :conversation
  end

  def trash
    conversation.mark_as_read(current_user)
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    # conversation.mark_as_unread(current_user)
    conversation.untrash(current_user)
    redirect_to :conversations
  end

  def perm_trash
    conversation.mark_as_read(current_user)
    conversation.opt_out(current_user)
    conversation.mark_as_deleted(current_user)
    conversation.untrash(current_user)
    redirect_to :conversations
  end

  def empty_trash
    if current_user.mailbox.trash.count > 0
      current_user.mailbox.empty_trash
      flash[:success] = "Your trash has been emptied."
      redirect_to :conversations
    else
      redirect_to :back
      flash[:info] = "Nothing to delete! Your trash is already empty."
    end
  end

  private
  
  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end

  def conversation_params(*keys)
    fetch_params(:conversation, *keys)
  end

  def message_params(*keys)
    fetch_params(:message, *keys)
  end

  def fetch_params(key, *subkeys)
    params[key].instance_eval do
      case subkeys.size
      when 0 then self
      when 1 then self[subkeys.first]
      else subkeys.map{|k| self[k] }
      end
    end
  end
end