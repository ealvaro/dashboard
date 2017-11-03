{a, div} = React.DOM

NUMERIC_FIELDS = ["api", "atfa", "average_quality", "ax", "ay", "az", "azm", "bit_depth", "batv", "dipa", "gama", "gravity", "gtfa", "gv0", "gv1", "gv2", "gv3", "gv4", "gv5", "gv6", "gv7", "inc", "hookload", "hole_depth", "magf", "delta_mtf", "mtfa", "mx", "my", "mz", "rop", "survey_md", "survey_tvd", "survey_vs", "temperature", "weight_on_bit", "annular_pressure", "bore_pressure", "battery_number", "power", "dl_power", "frequency", "formation_resistance", "signal", "noise", "s_n_ratio", "mag_dec", "grav_roll", "mag_roll", "gamma_shock", "gamma_shock_axial_p", "gamma_shock_tran_p"]
PUMP_FIELDS = ["pump_on_time", "pump_off_time", "pump_total_time"]
TRUTH_FIELDS = ["bat2", "batw", "dipw", "magw", "gravw", "tempw"]

EmTableData = React.createClass
  propTypes:
    object: React.PropTypes.object.isRequired
    okey: React.PropTypes.string.isRequired
    klass: React.PropTypes.string
    url: React.PropTypes.string
  nestedValue: (key) ->
    keys = key.split(".")
    value = this.props.object
    for key in keys
      return value unless value
      value = value[key]
    value
  formatValue: (value) ->
    key = this.props.okey
    object = this.props.object
    klass = this.props.klass
    switch key
      when "uid"
        value = emFormatUid value
        if klass == "Receiver"
          a href: object.active_url, value
        else
          div null, value
      when "job"
        if klass == "Receiver"
          a href: object.active_url, object.name
        else if this.props.url?
          a href: this.getUrl(), value
        else
          div null, value
      when "pump_state"
        div null, (value || "").toUpperCase()
      when "time_stamp"
        div null, emFormatDate object[key]
      when "time"
        div null, emFormatDate object[key]
      else
        if key in PUMP_FIELDS
          div null, emFormatPumpTime object[key]
        else if key in TRUTH_FIELDS
          div null, emFormatTruthy object[key]
        else if key in NUMERIC_FIELDS
          div null, emFormatNumber object[key], 2
        else
          div null, value
  getValue: -> this.nestedValue this.props.okey
  getUrl: -> this.nestedValue this.props.url
  render: ->
    this.formatValue this.getValue()

exports = this
exports.EmTableData = EmTableData
