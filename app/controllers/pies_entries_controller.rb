class PiesEntriesController < ApplicationController
  def create
    entry = @current_user.pies_entries.new(pies_entry_params)

    if entry.save
      render json: entry, status: :created
    else
      render json: { errors: entry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    entries = @current_user.pies_entries.order(checked_in_on: :desc)
    render json: entries
  end

  private

  def pies_entry_params
    params.require(:pies_entry).permit(
      :checked_in_on,
      :physical, :physical_description,
      :intellectual, :intellectual_description,
      :emotional, :emotional_description,
      :spiritual, :spiritual_description
    )
  end
end