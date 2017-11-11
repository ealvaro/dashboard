# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160201173940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "alerts", force: true do |t|
    t.string   "alertable_type"
    t.integer  "alertable_id"
    t.integer  "requester_id"
    t.integer  "assignee_id"
    t.string   "subject"
    t.text     "description"
    t.datetime "ignored_at"
    t.datetime "completed_at"
    t.integer  "severity"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "canceled_at"
  end

  add_index "alerts", ["assignee_id"], name: "index_alerts_on_assignee_id", using: :btree
  add_index "alerts", ["requester_id"], name: "index_alerts_on_requester_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "address_street"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "pricing"
    t.string   "address_city"
    t.string   "zip_code"
    t.string   "country"
    t.string   "address_state"
    t.boolean  "hidden",         default: false
  end

  create_table "csv_files", force: true do |t|
    t.integer "import_id"
    t.string  "file"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "damages", force: true do |t|
    t.integer  "run_id"
    t.string   "damage_group"
    t.integer  "original_amount_in_cents"
    t.integer  "amount_in_cents_as_billed"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "default_pricing_schemes", force: true do |t|
    t.json     "max_temperature"
    t.json     "max_shock"
    t.json     "max_vibe"
    t.json     "shock_warnings"
    t.json     "motor_bend"
    t.json     "rpm"
    t.json     "agitator_distance"
    t.json     "mud_type"
    t.json     "dd_hours"
    t.json     "mwd_hours"
    t.integer  "client_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: true do |t|
    t.integer  "report_type_id"
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["report_type_id"], name: "index_documents_on_report_type_id", using: :btree

  create_table "event_assets", force: true do |t|
    t.integer "event_id"
    t.string  "file"
    t.string  "name"
    t.string  "uid"
  end

  create_table "events", force: true do |t|
    t.integer  "tool_id"
    t.string   "event_type"
    t.datetime "time"
    t.string   "reporter_type"
    t.string   "software_installation_id"
    t.string   "board_firmware_version"
    t.string   "board_serial_number"
    t.string   "chassis_serial_number"
    t.string   "primary_asset_number"
    t.string   "secondary_asset_numbers"
    t.string   "user_email"
    t.string   "region"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "configs"
    t.string   "memory_usage_level"
    t.string   "hardware_version"
    t.string   "reporter_version"
    t.string   "job_number"
    t.integer  "run_number"
    t.string   "reporter_context"
    t.string   "tags"
    t.float    "max_temperature"
    t.float    "max_shock"
    t.integer  "shock_count"
    t.integer  "run_id"
    t.string   "client_name"
    t.string   "well_name"
    t.string   "rig_name"
    t.integer  "report_type_id"
    t.integer  "job_id"
    t.integer  "well_id"
    t.integer  "rig_id"
    t.integer  "client_id"
    t.integer  "region_id"
    t.string   "team_viewer_id"
    t.string   "team_viewer_password"
    t.string   "can_id"
  end

  add_index "events", ["client_id"], name: "index_events_on_client_id", using: :btree
  add_index "events", ["event_type"], name: "index_events_on_event_type", using: :btree
  add_index "events", ["job_id"], name: "index_events_on_job_id", using: :btree
  add_index "events", ["region_id"], name: "index_events_on_region_id", using: :btree
  add_index "events", ["report_type_id"], name: "index_events_on_report_type_id", using: :btree
  add_index "events", ["rig_id"], name: "index_events_on_rig_id", using: :btree
  add_index "events", ["tool_id"], name: "index_events_on_tool_id", using: :btree
  add_index "events", ["well_id"], name: "index_events_on_well_id", using: :btree

  create_table "exports", force: true do |t|
    t.integer "exportable_id"
    t.string  "exportable_type"
    t.string  "file"
  end

  create_table "firmware_updates", force: true do |t|
    t.string   "tool_type"
    t.string   "version"
    t.text     "summary"
    t.string   "binary"
    t.string   "hardware_version"
    t.string   "contexts",           array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "regions",            array: true
    t.string   "for_serial_numbers"
    t.integer  "last_edit_by_id"
  end

  create_table "formations", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "multiplier"
  end

  create_table "gammas", force: true do |t|
    t.integer  "run_id"
    t.float    "measured_depth"
    t.float    "count"
    t.float    "edited_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gammas", ["run_id"], name: "index_gammas_on_run_id", using: :btree

  create_table "histograms", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_number"
    t.integer  "job_id"
    t.integer  "run_id"
    t.json     "data"
  end

  create_table "histograms_tools", id: false, force: true do |t|
    t.integer "histogram_id"
    t.integer "tool_id"
  end

  add_index "histograms_tools", ["histogram_id"], name: "index_histograms_tools_on_histogram_id", using: :btree
  add_index "histograms_tools", ["tool_id"], name: "index_histograms_tools_on_tool_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "file"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_updates", force: true do |t|
    t.integer  "import_id",   null: false
    t.text     "description", null: false
    t.string   "update_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imports", force: true do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "installs", force: true do |t|
    t.string   "application_name"
    t.string   "version"
    t.string   "ip_address"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "team_viewer_id"
    t.string   "team_viewer_password"
    t.string   "user_email"
    t.string   "region"
    t.string   "reporter_context"
    t.string   "job_number"
    t.string   "run_number"
    t.string   "dell_service_number"
    t.string   "computer_category"
  end

  create_table "invoices", force: true do |t|
    t.string   "number"
    t.date     "date_of_issue"
    t.float    "discount_percent"
    t.json     "sent_to"
    t.json     "raw_invoice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.float    "multiplier_as_billed"
    t.float    "discount_percent_as_billed"
    t.integer  "total_in_cents"
    t.integer  "discount_in_cents"
  end

  create_table "jobs", force: true do |t|
    t.integer  "client_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "cache",      default: {"recent_updates"=>{"BtrReceiverUpdate"=>[], "LeamReceiverUpdate"=>[], "EmReceiverUpdate"=>[], "BtrControlUpdate"=>[], "LoggerUpdate"=>[]}}
    t.boolean  "inactive",   default: false
  end

  create_table "jobs_notifiers", id: false, force: true do |t|
    t.integer "job_id",      null: false
    t.integer "notifier_id", null: false
  end

  add_index "jobs_notifiers", ["job_id", "notifier_id"], name: "index_jobs_notifiers_on_job_id_and_notifier_id", using: :btree
  add_index "jobs_notifiers", ["notifier_id", "job_id"], name: "index_jobs_notifiers_on_notifier_id_and_job_id", using: :btree

  create_table "mandates", force: true do |t|
    t.string   "type"
    t.string   "public_token"
    t.datetime "expiration"
    t.integer  "occurences",                                         default: -1
    t.text     "for_tool_ids"
    t.integer  "priority"
    t.integer  "vib_trip_hi"
    t.integer  "vib_trip_lo"
    t.integer  "vib_trip_hi_a"
    t.integer  "vib_trip_lo_a"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contexts",                                                           array: true
    t.hstore   "gv_configs",                                                         array: true
    t.hstore   "thresholds"
    t.hstore   "logging_params"
    t.string   "version"
    t.integer  "pulse_min"
    t.integer  "pulse_max"
    t.integer  "pulse_close_period"
    t.integer  "pulse_close_duty"
    t.integer  "pulse_hold_duty"
    t.float    "flow_switch_threshold_strongly_on_high"
    t.float    "flow_switch_threshold_strongly_on_analog"
    t.float    "flow_switch_threshold_strongly_on_digital"
    t.float    "flow_switch_threshold_weakly_on_high"
    t.float    "flow_switch_threshold_weakly_on_analog"
    t.float    "flow_switch_threshold_weakly_on_digital"
    t.float    "flow_switch_threshold_off_high"
    t.float    "flow_switch_threshold_off_analog"
    t.float    "flow_switch_threshold_off_digital"
    t.integer  "flow_switch_weight_strongly_on_high"
    t.integer  "flow_switch_weight_strongly_on_analog_and_digital"
    t.integer  "flow_switch_weight_strongly_off_high"
    t.integer  "flow_switch_weight_strongly_off_analog_and_digital"
    t.integer  "flow_switch_weight_weakly_on_high"
    t.integer  "flow_switch_weight_weakly_on_analog_and_digital"
    t.integer  "flow_switch_weight_weakly_off_high"
    t.integer  "flow_switch_weight_weakly_off_analog_and_digital"
    t.string   "filters_std_dev"
    t.string   "string"
    t.boolean  "optional",                                           default: false
    t.float    "differential_diversion_threshold"
    t.float    "differential_diversion_threshold_high"
    t.integer  "high_or_low_threshold_percentage"
    t.integer  "high_timeout"
    t.integer  "low_timeout"
    t.integer  "requalification_timeout"
    t.integer  "diversion_crossing_threshold"
    t.integer  "diversion_integration_period"
    t.integer  "diversion_window"
    t.float    "kstd"
    t.float    "kskew"
    t.float    "kkurt"
    t.integer  "sample_period"
    t.string   "health_algorithm"
    t.string   "gamma_np"
    t.string   "tolteq_survey"
    t.string   "shock_radial"
    t.string   "shock_axial"
    t.string   "regions",                                                            array: true
    t.string   "name"
    t.integer  "power_off_timeout"
    t.float    "power_off_max_temp"
    t.float    "sif_threshold"
    t.float    "batt_hi_thresh"
    t.float    "batt_lo_thresh"
    t.integer  "sif_bin_0_max5"
    t.integer  "sif_bin_1_max5"
    t.integer  "sif_bin_2_max5"
    t.integer  "sif_bin_3_max5"
    t.integer  "sif_bin_0_max30"
    t.integer  "sif_bin_1_max30"
    t.integer  "sif_bin_2_max30"
    t.integer  "sif_bin_3_max30"
    t.integer  "sif_bin_4_max30"
    t.integer  "sif_bin_5_max30"
    t.integer  "sif_bin_6_max30"
    t.integer  "sif_bin_7_max30"
    t.integer  "sif_bin_8_max30"
    t.integer  "sif_bin_9_max30"
    t.integer  "sif_bin_10_max30"
    t.integer  "sif_bin_11_max30"
    t.integer  "sif_bin_12_max30"
    t.integer  "sif_bin_13_max30"
    t.integer  "sif_bin_14_max30"
    t.integer  "sif_bin_15_max30"
    t.integer  "sif_bin_16_max30"
    t.integer  "sif_bin_17_max30"
    t.integer  "sif_bin_18_max30"
    t.integer  "sif_bin_19_max30"
    t.integer  "sif_bin_20_max30"
    t.integer  "sif_bin_21_max30"
    t.integer  "sif_bin_22_max30"
    t.integer  "sif_bin_23_max30"
    t.integer  "sif_bin_24_max30"
    t.integer  "sif_bin_25_max30"
    t.integer  "sif_bin_26_max30"
    t.integer  "sif_bin_27_max30"
    t.integer  "sif_bin_28_max30"
    t.integer  "qbus_sleep_time"
    t.float    "ref_temp"
    t.float    "logging_period_in_secs"
    t.float    "max_survey_time_in_secs"
    t.integer  "diaa_timeout_in_mins"
    t.integer  "flow_inv_timeout_in_ms"
    t.integer  "thirteen_v_timeout_in_ms"
    t.integer  "delta_freq"
    t.float    "delta_threshold"
    t.float    "shock_threshold"
    t.boolean  "max_temp_flow"
    t.float    "bat_hi_thresh"
    t.float    "bat_lo_thresh"
    t.float    "bat_switch_in_secs"
    t.float    "bat_filter_coeff"
    t.boolean  "real_time_can"
    t.integer  "running_avg_window"
  end

  create_table "notifications", force: true do |t|
    t.integer  "notifier_id"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notifiable_type"
    t.integer  "notifiable_id"
    t.integer  "cleared_by_id"
    t.string   "completed_status"
    t.text     "description"
  end

  add_index "notifications", ["notifier_id"], name: "index_notifications_on_notifier_id", using: :btree

  create_table "notifiers", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.json     "configuration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden",            default: false
    t.json     "associated_data"
    t.integer  "notifierable_id"
    t.string   "notifierable_type"
  end

  add_index "notifiers", ["notifierable_id", "notifierable_type"], name: "index_notifiers_on_notifierable_id_and_notifierable_type", using: :btree

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_id", "searchable_type"], name: "index_pg_search_documents_on_searchable_id_and_searchable_type", using: :btree

  create_table "receipts", force: true do |t|
    t.string   "mandate_token"
    t.datetime "timestamp_utc"
    t.string   "tool_serial"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receiver_settings", force: true do |t|
    t.string   "type"
    t.integer  "job_id"
    t.integer  "rxdt"
    t.integer  "txdt"
    t.float    "sywf"
    t.integer  "nsyp"
    t.integer  "shsz"
    t.integer  "thsz"
    t.string   "hdck"
    t.string   "dwnl"
    t.integer  "dltp"
    t.string   "dlty"
    t.string   "dlsv"
    t.float    "inct"
    t.string   "evim"
    t.integer  "modn"
    t.float    "pw1"
    t.float    "pw2"
    t.float    "pw3"
    t.float    "pw4"
    t.integer  "ssn1"
    t.integer  "ssn2"
    t.integer  "ssn3"
    t.integer  "ssn4"
    t.integer  "tsn1"
    t.integer  "tsn2"
    t.integer  "tsn3"
    t.integer  "tsn4"
    t.integer  "aqt1"
    t.integer  "aqt2"
    t.integer  "aqt3"
    t.integer  "aqt4"
    t.integer  "tlt1"
    t.integer  "tlt2"
    t.integer  "tlt3"
    t.integer  "tlt4"
    t.text     "ssq1"
    t.text     "ssq2"
    t.text     "ssq3"
    t.text     "ssq4"
    t.text     "tsq1"
    t.text     "tsq2"
    t.text     "tsq3"
    t.text     "tsq4"
    t.string   "loc"
    t.float    "ndip"
    t.float    "dipt"
    t.float    "nmag"
    t.float    "magt"
    t.float    "mdec"
    t.float    "mxyt"
    t.float    "ngrv"
    t.float    "grvt"
    t.float    "tmpt"
    t.string   "cmtf"
    t.string   "tmtf"
    t.string   "dspc"
    t.string   "suam"
    t.float    "sudt"
    t.integer  "susr"
    t.float    "sust"
    t.integer  "stsr"
    t.float    "stst"
    t.integer  "mtty"
    t.string   "diaa"
    t.string   "diaf"
    t.string   "dfmt"
    t.string   "gspc"
    t.float    "gwut"
    t.integer  "gmin"
    t.integer  "gmax"
    t.float    "gsf"
    t.float    "sgsf"
    t.string   "gaaa"
    t.integer  "gupt"
    t.string   "gaaf"
    t.string   "gfmt"
    t.integer  "bevt"
    t.float    "bfs"
    t.float    "bthr"
    t.integer  "pmpt"
    t.integer  "pevt"
    t.float    "ptfs"
    t.float    "ptg"
    t.string   "fdm"
    t.integer  "fevt"
    t.string   "invf"
    t.integer  "lopl"
    t.integer  "hipl"
    t.string   "ptyp"
    t.string   "syty"
    t.float    "pwin",                       array: true
    t.string   "emtx"
    t.string   "resy"
    t.integer  "nssq"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version_number", default: 1
    t.integer  "key"
  end

  add_index "receiver_settings", ["job_id"], name: "index_receiver_settings_on_job_id", using: :btree

  create_table "receivers", force: true do |t|
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", force: true do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_request_assets", force: true do |t|
    t.integer  "report_request_id"
    t.string   "file"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_request_assets", ["report_request_id"], name: "index_report_request_assets_on_report_request_id", using: :btree

  create_table "report_request_types", force: true do |t|
    t.string   "name"
    t.string   "scaling"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_request_types_requests", id: false, force: true do |t|
    t.integer "report_request_id"
    t.integer "report_request_type_id"
  end

  add_index "report_request_types_requests", ["report_request_id"], name: "index_report_request_types_requests_on_report_request_id", using: :btree
  add_index "report_request_types_requests", ["report_request_type_id"], name: "index_report_request_types_requests_on_report_request_type_id", using: :btree

  create_table "report_requests", force: true do |t|
    t.float    "measured_depth"
    t.float    "inc"
    t.float    "azm"
    t.integer  "job_id"
    t.datetime "succeeded_at"
    t.datetime "failed_at"
    t.integer  "run_id"
    t.text     "description"
    t.string   "report_request_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "start_depth"
    t.string   "software_installation_id"
    t.string   "completed_by"
    t.integer  "requested_by_id"
    t.boolean  "las_export"
    t.boolean  "request_correction"
    t.float    "end_depth"
  end

  create_table "report_types", force: true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rig_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rig_groups_rigs", id: false, force: true do |t|
    t.integer "rig_group_id", null: false
    t.integer "rig_id",       null: false
  end

  create_table "rigs", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "run_records", force: true do |t|
    t.integer  "tool_id"
    t.integer  "run_id"
    t.integer  "max_temperature"
    t.float    "item_start_hrs"
    t.float    "circulating_hrs"
    t.float    "rotating_hours"
    t.float    "sliding_hours"
    t.float    "total_drilling_hours"
    t.float    "mud_weight"
    t.integer  "gpm"
    t.string   "bit_type"
    t.float    "motor_bend"
    t.integer  "rpm"
    t.integer  "chlorides"
    t.float    "sand"
    t.date     "brt"
    t.date     "art"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "import_id"
    t.integer  "bha"
    t.float    "agitator_distance"
    t.string   "mud_type"
    t.string   "agitator"
    t.float    "max_shock"
    t.float    "max_vibe"
    t.integer  "shock_warnings"
  end

  create_table "runs", force: true do |t|
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "well_id"
    t.integer  "rig_id"
    t.datetime "occurred"
    t.integer  "invoice_id"
    t.integer  "max_temperature_as_billed"
    t.float    "item_start_hrs_as_billed"
    t.float    "circulating_hrs_as_billed"
    t.float    "rotating_hours_as_billed"
    t.float    "sliding_hours_as_billed"
    t.float    "total_drilling_hours_as_billed"
    t.float    "mud_weight_as_billed"
    t.integer  "gpm_as_billed"
    t.string   "bit_type_as_billed"
    t.float    "motor_bend_as_billed"
    t.integer  "rpm_as_billed"
    t.integer  "chlorides_as_billed"
    t.float    "sand_as_billed"
    t.date     "brt_as_billed"
    t.date     "art_as_billed"
    t.integer  "bha_as_billed"
    t.float    "agitator_distance_as_billed"
    t.string   "mud_type_as_billed"
    t.string   "agitator_as_billed"
    t.json     "damages"
    t.float    "mwd_hours_as_billed"
    t.float    "dd_hours_as_billed"
    t.integer  "number"
    t.float    "max_shock_as_billed"
    t.float    "max_vibe_as_billed"
    t.integer  "shock_warnings_as_billed"
    t.json     "damages_as_billed"
  end

  create_table "side_tracks", force: true do |t|
    t.integer "run_id"
    t.integer "number"
    t.float   "origination_measured_depth"
  end

  add_index "side_tracks", ["run_id"], name: "index_side_tracks_on_run_id", using: :btree

  create_table "software_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "softwares", force: true do |t|
    t.integer  "software_type_id"
    t.string   "version"
    t.text     "summary"
    t.string   "binary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "softwares", ["software_type_id"], name: "index_softwares_on_software_type_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.integer  "run_id"
    t.text     "interests"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "threshold_setting_id"
  end

  add_index "subscriptions", ["job_id"], name: "index_subscriptions_on_job_id", using: :btree
  add_index "subscriptions", ["run_id"], name: "index_subscriptions_on_run_id", using: :btree
  add_index "subscriptions", ["threshold_setting_id"], name: "index_subscriptions_on_threshold_setting_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "survey_import_runs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.integer  "run_id"
    t.integer  "version_number",         default: 1
    t.integer  "user_id"
    t.string   "key"
    t.boolean  "hidden",                 default: false
    t.integer  "survey_import_run_id"
    t.decimal  "measured_depth_in_feet"
    t.decimal  "gx"
    t.decimal  "gy"
    t.decimal  "gz"
    t.decimal  "g_total"
    t.decimal  "hx"
    t.decimal  "hy"
    t.decimal  "hz"
    t.decimal  "h_total"
    t.string   "inclination"
    t.string   "azimuth"
    t.string   "dip_angle"
    t.string   "north"
    t.string   "east"
    t.string   "tvd"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "side_track_id"
    t.float    "horizontal_section"
    t.float    "dog_leg_severity"
    t.decimal  "start_depth"
    t.integer  "accepted_by_id"
    t.integer  "declined_by_id"
  end

  add_index "surveys", ["side_track_id"], name: "index_surveys_on_side_track_id", using: :btree

  create_table "templates", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "threshold_settings", force: true do |t|
    t.string  "name"
    t.integer "user_id"
    t.float   "pump_off_time_in_milliseconds"
    t.float   "max_temperature"
    t.float   "max_batv"
    t.float   "min_batv"
    t.boolean "batw"
    t.boolean "dipw"
    t.boolean "gravw"
    t.boolean "magw"
    t.boolean "tempw"
    t.float   "min_confidence_level"
  end

  add_index "threshold_settings", ["user_id"], name: "index_threshold_settings_on_user_id", using: :btree

  create_table "tool_types", force: true do |t|
    t.integer  "number"
    t.string   "klass"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tools", force: true do |t|
    t.string   "uid"
    t.integer  "tool_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "events_count",  default: 0
    t.string   "serial_number"
    t.json     "cache"
  end

  add_index "tools", ["tool_type_id"], name: "index_tools_on_tool_type_id", using: :btree

  create_table "truck_requests", force: true do |t|
    t.integer  "job_id"
    t.integer  "region_id"
    t.string   "priority"
    t.string   "user_email"
    t.string   "computer_identifier"
    t.string   "motors"
    t.string   "mwd_tools"
    t.string   "surface_equipment"
    t.string   "backhaul"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "status_history",      default: "{}", array: true
    t.json     "status",              default: {}
    t.string   "notes"
  end

  add_index "truck_requests", ["job_id"], name: "index_truck_requests_on_job_id", using: :btree

  create_table "updates", force: true do |t|
    t.string   "type"
    t.datetime "time"
    t.string   "job_number"
    t.integer  "job_id"
    t.string   "software_installation_id"
    t.string   "run_number"
    t.integer  "run_id"
    t.string   "client_name"
    t.integer  "client_id"
    t.string   "rig_name"
    t.integer  "rig_id"
    t.string   "well_name"
    t.integer  "well_id"
    t.string   "team_viewer_id"
    t.string   "team_viewer_password"
    t.float    "block_height"
    t.float    "hookload"
    t.float    "pump_pressure"
    t.float    "bit_depth"
    t.float    "weight_on_bit"
    t.float    "rotary_rpm"
    t.float    "rop"
    t.float    "voltage"
    t.float    "inc"
    t.float    "azm"
    t.float    "api"
    t.float    "hole_depth"
    t.float    "gravity"
    t.float    "dipa"
    t.string   "survey_md"
    t.float    "survey_tvd"
    t.float    "survey_vs"
    t.float    "temperature"
    t.boolean  "pumps_on"
    t.boolean  "on_bottom"
    t.boolean  "slips_out"
    t.float    "dao"
    t.string   "reporter_version"
    t.string   "decode_percentage"
    t.integer  "pump_on_time"
    t.integer  "pump_off_time"
    t.integer  "pump_total_time"
    t.float    "magf"
    t.float    "gama"
    t.float    "atfa"
    t.float    "gtfa"
    t.float    "mtfa"
    t.float    "mx"
    t.float    "my"
    t.float    "mz"
    t.float    "ax"
    t.float    "ay"
    t.float    "az"
    t.float    "batv"
    t.boolean  "batw"
    t.boolean  "dipw"
    t.boolean  "gravw"
    t.float    "gv0"
    t.float    "gv1"
    t.float    "gv2"
    t.float    "gv3"
    t.float    "gv4"
    t.float    "gv5"
    t.float    "gv6"
    t.float    "gv7"
    t.boolean  "magw"
    t.boolean  "tempw"
    t.string   "sync_marker"
    t.integer  "survey_sequence"
    t.integer  "logging_sequence"
    t.float    "confidence_level"
    t.string   "average_quality"
    t.string   "pump_state"
    t.float    "tf"
    t.json     "pulse_data"
    t.json     "table"
    t.json     "tool_face_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "bat2"
    t.float    "low_pulse_threshold"
    t.datetime "published_at"
    t.float    "power"
    t.float    "frequency"
    t.json     "filtered_waveform_data"
    t.float    "average_pulse"
    t.integer  "battery_number"
    t.float    "annular_pressure"
    t.float    "bore_pressure"
    t.float    "delta_mtf"
    t.float    "dl_power"
    t.boolean  "dl_enabled"
    t.float    "formation_resistance"
    t.float    "signal"
    t.float    "noise"
    t.float    "s_n_ratio"
    t.float    "mag_dec"
    t.float    "grav_roll"
    t.float    "mag_roll"
    t.float    "gamma_shock"
    t.float    "gamma_shock_axial_p"
    t.float    "gamma_shock_tran_p"
    t.float    "tfo"
    t.json     "fft"
    t.string   "uid"
  end

  add_index "updates", ["job_id"], name: "index_updates_on_job_id", using: :btree
  add_index "updates", ["run_id"], name: "index_updates_on_run_id", using: :btree
  add_index "updates", ["time"], name: "index_updates_on_time", using: :btree
  add_index "updates", ["updated_at"], name: "index_updates_on_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "roles",                               array: true
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.json     "settings"
    t.string   "follows",                default: [], array: true
  end

  create_table "wells", force: true do |t|
    t.string   "name"
    t.integer  "formation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
