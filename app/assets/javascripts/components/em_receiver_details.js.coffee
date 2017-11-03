{a, div, dl} = React.DOM

delm = (text, children) ->
  dt = React.DOM.dt key: 'dt', text
  dd = React.DOM.dd key: 'dd', children
  [dt, dd]

EmReceiverDetails = React.createClass
  propTypes:
    receiver: React.PropTypes.object.isRequired
    onHide: React.PropTypes.func.isRequired
  renderLink: (url, text) ->
    if url? then a href: url, text else text
  render: ->
    receiver = this.props.receiver
    div className: "row",
      div className: "col-md-4",
        dl className: "dl-horizontal",
          delm "UID", a href: receiver.active_url, emFormatUid receiver.uid
          delm "Job", this.renderLink receiver.job_show_url, receiver.job
          delm "Run", this.renderLink receiver.run_show_url, receiver.run
          delm "Client", receiver.client
          delm "Rig", receiver.rig
          delm "Well", receiver.well
          delm "TV ID", receiver.team_viewer_id
          delm "TV Pwd", receiver.team_viewer_password
          delm "Decode %", receiver.decode
          delm "Version", receiver.reporter_version
          delm "Pump On Time", emFormatPumpTime receiver.pump_on_time
          delm "Pump Off Time", emFormatPumpTime receiver.pump_off_time
          delm "Pump Total Time", emFormatPumpTime receiver.pump_total_time
          delm "Average Quality", receiver.average_quality
          delm "Time", emFormatDate receiver.time_stamp
          delm "TF", receiver.tf
          delm "TFO", receiver.tfo
          delm "DAO", receiver.dao
          delm "Gravity", emFormatNumber receiver.gravity
          delm "Gravity Roll", emFormatNumber receiver.grav_roll
          delm "Mag Roll", emFormatNumber receiver.mag_roll
          delm "MagF", emFormatNumber receiver.magf
          delm "DIPA", emFormatNumber receiver.dipa
          delm "Temperature", emFormatNumber receiver.temp
          delm "Gama", emFormatNumber receiver.gama
          delm "Gamma Shock (g)", emFormatNumber receiver.gamma_shock
          delm "amma Axial Shock (g)", emFormatNumber receiver.gamma_shock_axial_p
          delm "Gamma Transverse Shock (g)", emFormatNumber receiver.gamma_shock_tran_p
          delm "ATFA", emFormatNumber receiver.atfa
          delm "GTFA", emFormatNumber receiver.gtfa
          delm "MTFA", emFormatNumber receiver.mtfa
          delm "Delta MTF", emFormatNumber receiver.delta_mtf
          delm "Formation Resistance", emFormatNumber receiver.formation_resistance
      div className: "col-md-4",
        dl className: "dl-horizontal",
          delm "Mx", emFormatNumber receiver.mx
          delm "My", emFormatNumber receiver.my
          delm "Mz", emFormatNumber receiver.mz
          delm "Ax", emFormatNumber receiver.ax
          delm "Ay", emFormatNumber receiver.ay
          delm "Az", emFormatNumber receiver.az
          delm "BATV", emFormatNumber receiver.batv
          delm "BATW", emFormatTruthy receiver.batw
          delm "DIPW", emFormatTruthy receiver.dipw
          delm "GRAVW", emFormatTruthy receiver.gravw
          delm "GV0", emFormatNumber receiver.gv0
          delm "GV1", emFormatNumber receiver.gv1
          delm "GV2", emFormatNumber receiver.gv2
          delm "GV3", emFormatNumber receiver.gv3
          delm "GV4", emFormatNumber receiver.gv4
          delm "GV5", emFormatNumber receiver.gv5
          delm "GV6", emFormatNumber receiver.gv6
          delm "GV7", emFormatNumber receiver.gv7
          delm "MAGW", emFormatTruthy receiver.magw
          delm "TEMPW", emFormatTruthy receiver.tempw
          delm "dl Enabled", emFormatTruthy receiver.dl_enabled
          delm "Sync Marker", receiver.sync_marker
          delm "SuSq", receiver.survey_sequence
          delm "TLSq", receiver.logging_sequence
          delm "Confidence Level", receiver.confidence_level
          delm "Pump State", receiver.pump_state
      div className: "col-md-3",
        dl className: "dl-horizontal",
          delm "Block Height", emFormatNumber receiver.block_height
          delm "Hookload", emFormatNumber receiver.hookload
          delm "Pump Pressure", emFormatNumber receiver.pump_pressure
          delm "Bit Depth", emFormatNumber receiver.bit_depth
          delm "WOB", emFormatNumber receiver.weight_on_bit
          delm "Rotary RPM", emFormatNumber receiver.rotary_rpm
          delm "ROP", emFormatNumber receiver.rop
          delm "Voltage", receiver.voltage
          delm "INC", emFormatNumber receiver.inc
          delm "AZM", emFormatNumber receiver.azm
          delm "API", receiver.api
          delm "Hole Depth", emFormatNumber receiver.hole_depth
          delm "Survey MD", emFormatNumber receiver.survey_md
          delm "Survey TVD", emFormatNumber receiver.survey_tvd
          delm "Survey VS", emFormatNumber receiver.survey_vs
          delm "Temperature", receiver.temperature
          delm "Pumps On", receiver.pumps_on
          delm "On Bottom", receiver.on_bottom
          delm "Slips Out", receiver.slips_out
          delm "Last Updated", emFormatDate receiver.updated_at
      div className: "col-md-1 text-right",
        a
          className: "btn btn-danger",
          onClick: this.props.onHide
          "Hide"


exports = this
exports.EmReceiverDetails = EmReceiverDetails
