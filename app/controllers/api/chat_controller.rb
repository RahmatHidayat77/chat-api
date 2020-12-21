class Api::ChatController < ApplicationController

    def send_message
        if send_message_params[:from].present? && send_message_params[:to].present? && send_message_params[:text].present?

            from = findUser(send_message_params[:from])

            to = findUser(send_message_params[:to])

            message_params = {
                from_user_id: from.id,
                to_user_id: to.id,
                text: send_message_params[:text]
            }

            messages = Chat.new(message_params)
            messages.save!

            response = { message: Message.send_success, from: from.name, to: to.name,  text: send_message_params[:text] }
            json_response(response, :ok)
        else
            raise(ExceptionHandler::ParamsRequired, Message.params_cannot_null)
        end
    end

    def list_message
        response = {}
        items = []
        if list_message_params[:from].present? && list_message_params[:to].present?
            from = findUser(list_message_params[:from])
            to = findUser(list_message_params[:to])
            chats = Chat.where("(from_user_id = #{from.id} && to_user_id = #{to.id}) OR (from_user_id = #{to.id} && to_user_id = #{from.id})").order("created_at")

            # update unread to read
            Chat.where("from_user_id = #{to.id} && to_user_id = #{from.id}").where(read: false).update(read: true)
            
            chats.each do |x|
                name = ""
                if x.from_user_id == from.id 
                    name = from.name
                else
                    name = to.name
                end

                chat = {
                    name: name,
                    text: x.text,
                    time: x.created_at.strftime("%d/%m/%Y %k:%M")
                }

                items.push(chat)
            end 
            
            response[:list_message] = items
            json_response(response, :ok)
        else
            raise(ExceptionHandler::ParamsRequired, Message.params_cannot_null)
        end
    end

    def list_all_conversation
        response = {}
        items = []
        if list_all_message_params[:user].present?
            user = findUser(list_all_message_params[:user])
            user_id = user.id

            chat_with = User.select("users.id, users.name").joins("join chats ON users.id = chats.from_user_id")
                            .where("chats.to_user_id = #{user_id}").group("users.id, users.name")

            chat_with.each do |x|
                last_message = Chat.select("text").where("(from_user_id = #{user_id} && to_user_id = #{x.id}) OR (from_user_id = #{x.id} && to_user_id = #{user_id})").order("created_at").last

                unread_count = Chat.where("(from_user_id = #{user_id} && to_user_id = #{x.id}) OR (from_user_id = #{x.id} && to_user_id = #{user_id})").where(read: false).count

                chat = {
                    from: user.name,
                    to: x.name,
                    last_message: last_message.text,
                    unread_count: unread_count
                }

                items.push(chat)
            end 
            
            response[:user_name] = user.name
            response[:summary_all_conversation] = items
            json_response(response, :ok)
        else
            raise(ExceptionHandler::ParamsRequired, Message.params_cannot_null)
        end
    end

    def update_message
        if update_message_params[:from_user].present? && update_message_params[:old_text].present? && update_message_params[:new_text].present? 
            user = findUser(update_message_params[:from_user])
            Chat.where(from_user_id: user.id).where(text: update_message_params[:old_text]).update(text: update_message_params[:new_text])

            response = { message: Message.update_success, from: update_message_params[:old_text], to: update_message_params[:new_text]}
            json_response(response, :ok)
        else
            raise(ExceptionHandler::ParamsRequired, Message.params_cannot_null)
        end
    end

    private

    def send_message_params
        params.permit(:from, :to, :text)
    end

    def list_message_params
        params.permit(:from, :to)
    end

    def list_all_message_params
        params.permit(:user)
    end

    def update_message_params
        params.permit(:from_user, :old_text, :new_text)
    end

    def findUser(phone)
        user = User.where(phone_number: phone).first
        if user.nil?
          raise(ActiveRecord::RecordNotFound, Message.not_found)
        end
        return user
    end
end