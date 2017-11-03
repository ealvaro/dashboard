module BillableRun
  extend ActiveSupport::Concern

  included do
    #define 'as_billed' fields
    @@as_billed_fields =  %i( max_temperature
                              max_shock
                              max_vibe
                              shock_warnings
                              item_start_hrs
                              circulating_hrs
                              rotating_hours
                              sliding_hours
                              total_drilling_hours
                              mud_weight
                              gpm
                              bit_type
                              motor_bend
                              rpm
                              chlorides
                              sand
                              brt
                              art
                              bha
                              agitator_distance
                              mud_type
                              agitator )

    @@as_billed_fields.each do |attr|
      define_method( "#{attr.to_s}_as_billed" ) do
        if tmp = read_attribute( "#{attr.to_s}_as_billed" )
          tmp
        elsif tmp = run_records.maximum( attr )
          tmp
        else
          nil
        end
      end
    end

    def dd_hours
      read_attribute( :dd_hours_as_billed ) || ( rotating_hours_as_billed + sliding_hours_as_billed )
    end

    def mwd_hours
      read_attribute( :mwd_hours_as_billed ) || ( rotating_hours_as_billed + sliding_hours_as_billed )
    end

    def damages_as_billed
      read_attribute( :damages_as_billed ) || {}
    end

    def cleanup_invoice_destroy!
      @@as_billed_fields.each do |sym|
        str = sym.to_s + "_as_billed="
        self.send(str, nil)
      end
      self.invoice_id = nil
      self.save!
    end
  end
end
