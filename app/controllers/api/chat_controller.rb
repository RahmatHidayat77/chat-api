class Api::ChatController < ApplicationController
    # before_action :set_user, only: [:show, :edit, :update, :destroy]
    # skip_before_action :authorize_request, only: :create

    def send_message
        if send_message_params[:from].present? && send_message_params[:to].present? && send_message_params[:text].present?
            # check if sender is present
            from = User.where(phone_number: send_message_params[:from]).first
            if from.nil?
              raise(ActiveRecord::RecordNotFound, Message.not_found)
            end

            # check if receiver is present
            to = User.where(phone_number: send_message_params[:to]).first
            if from.nil?
              raise(ActiveRecord::RecordNotFound, Message.not_found)
            end

            message_params = {
                from_user_id: from.id,
                to_user_id: to.id,
                text: send_message_params[:text]
            }

            messaged = Chat.new(message_params)
            messaged.save!
        else
            raise(ExceptionHandler::ParamsRequired, Message.params_cannot_null)
        end
    end

    private

    def send_message_params
        params.permit(:from, :to, :text)
    end

end