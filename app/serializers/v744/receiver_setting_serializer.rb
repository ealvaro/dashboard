class V744::ReceiverSettingSerializer < ActiveModel::Serializer
  attributes :created_at, :updated_at, :job_number, :job_id, :id, :type,
             :rxdt, :txdt, :sywf, :nsyp, :shsz, :thsz, :hdck, :dwnl, :dltp,
             :dlty, :dlsv, :inct, :evim, :modn, :pw1, :pw2, :pw3, :pw4,
             :ssn1, :ssn2, :ssn3, :ssn4, :tsn1, :tsn2, :tsn3, :tsn4,
             :aqt1, :aqt2, :aqt3, :aqt4, :tlt1, :tlt2, :tlt3, :tlt4,
             :ssq1, :ssq2, :ssq3, :ssq4, :tsq1, :tsq2, :tsq3, :tsq4,
             :loc, :ndip, :dipt, :nmag, :magt, :mdec, :mxyt, :ngrv, :grvt,
             :tmpt, :cmtf, :tmtf, :dspc, :suam, :sudt, :susr, :sust, :stsr,
             :stst, :mtty, :diaa, :diaf, :dfmt, :gspc, :gwut, :gmin, :gmax,
             :gsf, :sgsf, :gaaa, :gupt, :gaaf, :gfmt, :bevt, :bfs, :bthr,
             :pmpt, :pevt, :ptfs, :ptg, :fdm, :fevt, :invf, :lopl, :hipl,
             :ptyp, :syty, :pwin, :emtx, :resy, :nssq

  def id
    object.key
  end

  def job_number
    object.job.try(:name)
  end
end
