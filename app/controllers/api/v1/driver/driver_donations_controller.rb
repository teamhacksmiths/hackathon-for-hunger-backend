class Api::V1::Driver::DriverDonationsController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    @pending_donations = Donation.where(status_id: 0)
    @user_donations = current_user.donations.all
    render json: {
        donations: [ActiveModel::ArraySerializer.new(@pending_donations, each_serializer: DonationSerializer, root: false),
                    ActiveModel::ArraySerializer.new(@user_donations, each_serializer: DonationSerializer, root: false)]
      }
  end

  def update
    donation = current_user.donations.find(params[:id])
    if donation.update(donation_params)
      render json: donation, status: 200, location: [:api_v1, donation]
    else
      render json: { errors: donations.errors }, status: 422
    end
  end

  def status
    @donation = current_user.donations.find(params[:donation_id])
    if params[:status][:donation_status]
      @donation.status = DonationStatus.find(params[:status][:donation_status])
    end
    if params[:status][:pickup_status]
      @donation.pickup.pickupstatus = Pickupstatus.find(params[:status][:pickup_status])
      @donation.pickup.save
    end
    if params[:status][:dropoff_status]
      @donation.dropoff.dropoffstatus = Dropoffstatus.find(params[:status][:dropoff_status])
      @donation.dropoff.save
    end
    if @donation.save
      head 204
    else
      head 422
    end
  end


  def pending
    @pending_donations = Donation.where(status_id: 0)

    render json:{
        donations: ActiveModel::ArraySerializer.new(@pending_donations,
                                                    each_serializer: DonationSerializer,
                                                    root: false)
      }, status: 200
  end

  def accepted
    @donations = current_user.donations.all
    @accepted_donations = @donations.where(status_id: 1)
    render json: {
        donations: ActiveModel::ArraySerializer.new(@accepted_donations,
                                                    each_serializer: DonationSerializer,
                                                    root: false)
      }, status: 200
  end

  def completed
    @donations = current_user.donations.all
    @completed_donations = @donations.where(status_id: 2)
    render json: {
        donations: ActiveModel::ArraySerializer.new(@completed_donations,
                                                    each_serializer: DonationSerializer,
                                                    root: false)
      }, status: 200
  end

  def suspended
    @donations = current_user.donations.all
    @cancelled_donations = @donations.where(status_id: 3)
    render json: {
      donations: ActiveModel::ArraySerializer.new(@cancelled_donations,
                                                  each_serializer: DonationSerializer,
                                                  root: false)
    }
  end

  def cancelled
    @donations = current_user.donations.all
    @cancelled_donations = @donations.where(status_id: 4)
  end

  private

    def donation_params
      params.require(:donation).permit(:id, :description, :status_id)
    end

    def status_params
      params.require(:donation).permit(:donation_status,
                                       :pickup_status,
                                       :dropoff_status)
    end
end