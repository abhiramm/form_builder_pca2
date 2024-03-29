module Rapidfire
  class AnswerGroupsController < Rapidfire::ApplicationController
    before_filter :find_question_group!

    def new
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)
      Rails.logger.info "Inside Answer groups controller in new method #{answer_group_params}"
      @device = Device.find_by_device_id(params[:device_id])
      if @device and @device.authorized
        @child = @device.parent.children.first
      end
    end

    def create
      @answer_group_builder = AnswerGroupBuilder.new(answer_group_params)

      if @answer_group_builder.save
        redirect_to main_app.form_builder_registered_path, :gflash => { :success => 'Thanks for submitting the form' }
      else
        render main_app.form_builder_registered_path, :gflash => { :success => 'Thanks for submitting the form' }
      end
    end

    private
    def find_question_group!
      @question_group = QuestionGroup.find(params[:question_group_id])
    end

    def answer_group_params
      answer_params = { params: params[:answer_group] }
      Rails.logger.info "answer_group#{params[:answer_group]}"
      
      # Have changed current_user to parent since we dont have user session for parent
      if params[:child_id]
        child = Child.find_by_id(params[:child_id])

      answer_params.merge(user: child, question_group: @question_group)
    else
      answer_params.merge(user: current_user, question_group: @question_group)
    end
      
    end
  end
end
