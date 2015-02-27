module ConversationHelper

  def convo_subject(convo)
    convo.subject.titleize
  end

  def convo_link(convo)
    conversation_path(convo)
  end

  def has_unread?
    current_user && current_user.receipts.is_unread.length > 0 
  end

  def user_profile
    user_profile = request.original_url
  end

  def unread_message_count
    current_user && current_user.receipts.is_unread.length
  end

  def css_unread?(conversation)
    conversation.receipts.where(is_read: false).count > 0 ? "unread" : "read"
  end

  def message_name
    if conversation.recipients.length >= 2
      if current_user.full_name != nil && conversation.recipients[0].full_name == current_user.full_name
         "Your conversation with<br>".html_safe + conversation.recipients[1].full_name

      elsif current_user.full_name != nil && conversation.recipients[1].full_name == current_user.full_name
         "Your conversation with<br>".html_safe + conversation.recipients[0].full_name
      end
    else
      # Display none if no recipients of message
    end
  end
end
