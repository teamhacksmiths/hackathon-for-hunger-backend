class Api::V1::DonationsController < ApplicationController
  respond_to :json

  def show
    respond_with Donation.find(params[:id])
  end

  def index
    respond_with Product.all
  end

  # For creating a new donation:
  def create
    donation = current_user.donations.build(donation_params)
    if donation.save
      render json: product, status: 201, location: [:api, donation]
    else
      render json: { errors: donations.errors }, status: 422
    end
  end

  private

  def donation_params
    params.require(:donation).permit(:recipient, :status_id) #TODO: add params for donations
  end

  # TODO: add a better mechanism for how the recipient is created.
  def recipient_params
    params.require(:recipient)
  end
  # before_filter :find_donation, only: [:show, :update]
  #
  # before_filter only: :create do
  #   unless @json.has_key?('donation') && @json['donation'].responds_to(:[]) && @json['donation']['id']
  #
  #     render nothing: true, status: :bad_request
  #   end
  # end
  #
  # # Check that the request has a donation object.
  # before_filter only: :update do
  #   unless @json.has_key?('donation')
  #     render nothing: true, status: :bad_request
  #   end
  # end
  #
  # # Before creating, check to see if a donation already exists
  # before_filter only: :create do
  #   id = @json['donation']['id']
  #   @donation = Donation.find_by_id(id)
  # end
  #
  # # Index action will send a JSON Object for the donation where the given
  # # donor_id is equal to the current user's id.
  # def index
  #   render json: Donation.where('donor_id = ?', @user.id)
  # end
  #
  # def show
  #   render json: @donation
  # end
  #
  # def update
  #   @donation.assign_attributes(@json['donation'])
  #   if @donation.save
  #     render json: @donation
  #   else
  #     render nothing: true, status: :bad_request
  #   end
  # end
  #
  # private
  #
  # def find_donation
  #   @donation = find_by_id(params[:id])
  #   unless @donation.present? && @donation.user = @user
  #     render nothing: true, status: :not_found
  #   end
  # end

end
