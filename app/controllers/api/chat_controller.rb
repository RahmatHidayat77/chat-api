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

    private

    def send_message_params
        params.permit(:from, :to, :text)
    end

    def list_message_params
        params.permit(:from, :to)
    end

    def findUser(phone)
        user = User.where(phone_number: phone).first
        if user.nil?
          raise(ActiveRecord::RecordNotFound, Message.not_found)
        end
        return user
    end
end