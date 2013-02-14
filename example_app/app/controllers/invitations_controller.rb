class InvitationsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_inviter = SurveyInviter.new('', '')
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @survey_inviter = SurveyInviter.new(message, recipients)
    if @survey_inviter.valid?
      recipient_list.each do |email|
        invitation = Invitation.create(
          survey: @survey,
          sender: current_user,
          recipient_email: email,
          status: 'pending'
        )
        Mailer.invitation_notification(invitation, message)
      end
      redirect_to survey_path(@survey), notice: 'Invitation successfully sent'
    else
      @recipients = recipients
      @message = message
      render 'new'
    end
  end

  private

  def invalid_recipients
    @survey_inviter.invalid_recipients
  end

  def recipient_list
    @survey_inviter.recipient_list
  end

  def recipients
    params[:invitation][:recipients]
  end

  def message
    params[:invitation][:message]
  end
end
