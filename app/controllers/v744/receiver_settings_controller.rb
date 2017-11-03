class V744::ReceiverSettingsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    @setting = setting_class.new setting_params
    @setting.job = job if job.present?

    if @setting.save
      render json: @setting, root: false
    else
      render json: @setting.errors.full_messages, root: false,
             status: :bad_request
    end
  end

  def index
    @settings = ReceiverSetting.by_job(job) if job.present?
    if params[:type].present?
      @settings ||= ReceiverSetting
      @settings = @settings.where("type = ?", params[:type])
    end
    @settings ||= ReceiverSetting.all

    render json: @settings.latest_versions, root: false,
           each_serializer: V744::ReceiverSettingSerializer
  end

  def update
    setting = ReceiverSetting.find_by(key: params[:id])
    if setting.present?
      @setting = setting.versions.last.versioned_dup
      @setting.pwin = params[:pwin] if params[:pwin].present?
      @setting.update_attributes setting_params
      render json: @setting, root:false
    else
      error = "id #{params[:id]} not found"
      render json: {error: error}, root:false, status: :bad_request
    end
  end

  private

  def job
    @job ||= Job.fuzzy_find params[:job_number] if params[:job_number].present?
  end

  def setting_class
    case params[:type]
    when "BtrSlaveSetting"
      setting_class = BtrSlaveSetting
    when "LrxSlaveSetting"
      setting_class = LrxSlaveSetting
    else # "BtrSetting"
      setting_class = BtrSetting
    end
  end

  def setting_params
    params.permit(:rxdt, :txdt, :sywf, :nsyp, :shsz, :thsz, :hdck, :dwnl, :dltp,
                  :dlty, :dlsv, :inct, :evim, :modn, :pw1, :pw2, :pw3, :pw4,
                  :ssn1, :ssn2, :ssn3, :ssn4, :tsn1, :tsn2, :tsn3, :tsn4,
                  :aqt1, :aqt2, :aqt3, :aqt4, :tlt1, :tlt2, :tlt3, :tlt4,
                  :ssq1, :ssq2, :ssq3, :ssq4, :tsq1, :tsq2, :tsq3, :tsq4,
                  :loc, :ndip, :dipt, :nmag, :magt, :mdec, :mxyt, :ngrv, :grvt,
                  :tmpt, :cmtf, :tmtf, :dspc, :suam, :sudt, :susr, :sust, :stsr,
                  :stst, :mtty, :diaa, :diaf, :dfmt, :gspc, :gwut, :gmin, :gmax,
                  :gsf, :sgsf, :gaaa, :gupt, :gaaf, :gfmt, :bevt, :bfs, :bthr,
                  :pmpt, :pevt, :ptfs, :ptg, :fdm, :fevt, :invf, :lopl, :hipl,
                  :ptyp, :syty, :pwin, :emtx, :resy, :nssq)
  end
end
