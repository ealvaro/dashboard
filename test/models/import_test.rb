require "test_helper"

class ImportTest < ActiveSupport::TestCase
  test 'should set headers' do
    import = run_import
    assert_equal( import.headers, good_headers )
  end

  test 'should create runs' do
    run_import
    assert_equal( Run.count, 3 )
  end

  test 'should create tools' do
    run_import
    assert_equal( Tool.billable.length, 7 )
  end

  test 'should create tool types' do
    count = ToolType.count
    run_import
    assert_equal( ToolType.count, count + 4 )
  end

  test 'should create one formation' do
    run_import
    assert_equal( Formation.count, 1 )
  end

  test 'should set the correct run record values' do
    run_import

    RunRecord.last.tap do |rr|
      assert( rr.import_id )
      assert_equal( rr.run.job.name, "OK-140504" )
      assert_equal( rr.run.job.client.name, "Apache" )
      assert_equal( rr.run.well.rigs.first.name, "PATTERSON 154" )
      assert_equal( rr.run.well.name, "FAGALA 25" )
      assert_equal( rr.run.well.formation.name, "Formation 1" )
      assert_equal( rr.tool.serial_number, "B5731" )
      assert_equal( rr.tool.tool_type.name, "Steel Collars")
      assert_equal( rr.tool.tool_type.description, "DD")
      assert_equal( rr.run.send( :number          ), 1 )
      assert_equal( rr.send( :bha                 ), 2 )
      assert_equal( rr.send( :max_temperature     ), 138 )
      assert_equal( rr.send( :circulating_hrs     ), 0 )
      assert_equal( rr.send( :rotating_hours      ), 0 )
      assert_equal( rr.send( :sliding_hours       ), 4 )
      assert_equal( rr.send( :total_drilling_hours), 0 )
      assert_equal( rr.send( :mud_weight          ), 9.1 )
      assert_equal( rr.send( :gpm                 ), 450 )
      assert_equal( rr.send( :bit_type            ), "PDC" )
      assert_equal( rr.send( :motor_bend          ), 1.75 )
      assert_equal( rr.send( :rpm                 ), 0 )
      assert_equal( rr.send( :chlorides           ), 800 )
      assert_equal( rr.send( :sand                ), 0.2 )
      assert_equal( rr.send( :agitator            ), "Y" )
      assert_equal( rr.send( :agitator_distance   ), 12.5 )
      assert_equal( rr.brt.to_s, Date.new( 2014,05,04 ).to_s )
      assert_equal( rr.art.to_s, Date.new( 2014,05,06 ).to_s )

    end
  end

  def run_import
    import = create( :import )
    import.import_file( File.read( "#{Rails.root}/test/fixtures/import.csv" ) )
    import
  end

  def csv_files
    csv_file = OpenStruct.new()
    file = OpenStruct.new()
    file.url = "#{Rails.root}/test/fixtures/import.csv"
    csv_file.file = file
    csvs = [csv_file]

    csvs
  end

  def good_headers
    {:job_name=>0,
     :customer=>1,
     :rig_name=>2,
     :well_name=>3,
     :formation_name=>4,
     :tool_description=>5,
     :name=>6,
     :tool_serial_number=>7,
     :run_number=>8,
     :bha=>9,
     :max_temperature=>10,
     :circulating_hrs=>11,
     :rotating_hours=>12,
     :sliding_hours=>13,
     :total_drilling_hours=>14,
     :mud_weight=>15,
     :gpm=>16,
     :bit_type=>17,
     :motor_bend=>18,
     :rpm=>19,
     :chlorides=>20,
     :sand=>21,
     :mud_type=>22,
     :agitator=>23,
     :agitator_distance=>24,
     :brt=>25,
     :art=>26}
  end
end
