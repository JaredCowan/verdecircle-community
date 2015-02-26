class ConversationsController < ApplicationController
  skip_authorization_check
  helper_method :mailbox, :conversation
  respond_to :html, :json
  # load_and_authorize_resource

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

    redirect_to :conversations
    # redirect_to :back
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