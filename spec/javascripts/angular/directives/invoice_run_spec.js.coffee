$scope = undefined;
$rootScope = undefined;
$compile = undefined;
elem = undefined;
scope = undefined;
invoice = { client : {name: 'apache', pricing: {'max_temperature' : { '311' : { 'amount' : 3000000, 'description' : "Temperature over 311" }, '319' : { 'amount' : 5500000, 'description' : "Temperature over 319" } },'max_shock' : { '6.0' : { 'amount' : 3000000, 'description' : "Shock over 6" }, '9.0' : { 'amount' : 5500000, 'description' : "Shock over 9" } },'max_vibe' : { '6.0' : { 'amount' : 3000000, 'description' : "Vibe over 6" }, '9.0' : { 'amount' : 5500000, 'description' : "Vibe over 9" } },'shock_warnings' : { '1000' : { 'amount' : 100000, 'description' : "Shock warnings over 1000" }, '2000' : { 'amount' : 200000, 'description' : "Shock warnings over 2000" } }, 'motor_bend' :  { '2.0' : { 'amount' : 111, 'description' : "Motor bend over 2.0" } }, 'rpm' :  { '70' : { 'amount' : 111, 'description' : "RPM over 70" } }, 'agitator_distance' :  {'0.0' : {'amount' : 123, 'description' : 'Agitator present'}, '10.0' : { 'amount' : 222, 'description' : "Agitator distance over 10" } }, 'mud_type' : { 'water_based_mud' :{ 'sand' :  { '1.0' : { 'amount' : 333, 'description' : "Sand over 1" } }, 'chlorides' :  { '1000' : { 'amount' : 444, 'description' : "Chlorides over 1000" } }}}, 'dd_hours' :  { '24.0' : { 'amount' : 555, 'description' : "DD hours over 24" }, '100.0' : { 'amount' : 666, 'description' : "DD hours over 100" } }, 'mwd_hours' :  { '24.0' : { 'amount' : 555, 'description' : "MWD hours over 24" }, '100.0' : { 'amount' : 666, 'description' : "MWD hours over 100" } } }}}

describe 'invoice run', ->

  beforeEach module( 'erdos' )
  beforeEach module( 'templates' )
  beforeEach inject( (_$compile_, _$rootScope_) ->
    $scope = _$rootScope_.$new()
    $scope.run = {"damages_as_billed":{}, "number":255, "created_at":"2014-07-31T14:52:12.356-05:00", "updated_at":"2014-07-31T14:52:12.356-05:00", "job_id":1, "show_url":"/billing/runs/1", "edit_url":"/billing/runs/1/edit", "rig": {"id":1, "name":"PATTERSON 154", "created_at":"2014-07-31T14:52:11.444-05:00", "updated_at":"2014-07-31T14:52:11.444-05:00"}, "well": {"id":1, "name":"FAGALA 24-21-24 #1H", "formation_id":null, "created_at":"2014-07-31T14:52:11.641-05:00", "updated_at":"2014-07-31T14:52:11.641-05:00"}, "max_temperature_as_billed":138, "item_start_hrs_as_billed":null, "circulating_hrs_as_billed":41.5, "rotating_hours_as_billed":2.25, "sliding_hours_as_billed":31.25, "total_drilling_hours_as_billed":525.41, "mud_weight_as_billed":9.2, "gpm_as_billed":450, "bit_type_as_billed":"PDC", "motor_bend_as_billed":1.38, "rpm_as_billed":0, "chlorides_as_billed":1200, "sand_as_billed":0.3, "brt_as_billed":"2014-04-29", "art_as_billed":"2014-05-02", "bha_as_billed":1, "agitator_distance_as_billed":null, "mud_type_as_billed":null, "agitator_as_billed":null, "dd_hours_as_billed":33.5, "damage_as_billed": {}, "run_records":[{"id":1, "tool_id":1, "run_id":1, "max_temperature":138, "item_start_hrs":null, "circulating_hrs":41.5, "rotating_hours":2.25, "sliding_hours":31.25, "total_drilling_hours":119, "mud_weight":9.2, "gpm":450, "bit_type":"PDC", "motor_bend":2.38, "rpm":0, "chlorides":1200, "sand":0.3, "brt":"2014-04-29", "art":"2014-05-02", "created_at":"2014-07-31T14:52:12.360-05:00", "updated_at":"2014-07-31T14:52:12.360-05:00", "import_id":1, "bha":1, "agitator_distance":null, "mud_type":null, "agitator":null}]}
    $scope.invoice = invoice
    $compile = _$compile_;
    elem = $compile( "<invoice-run run='run' invoice='invoice'></invoice-run>" )($scope)
    scope = elem.scope()
    scope.$apply()
  )

  describe "when the user changes motor bend", ->
    beforeEach ->
      expect(scope.run.damages_as_billed.motor_bend.amount).not.toBeDefined()

    it "should add motor bend damages", ->
      scope.run.motor_bend_as_billed = 2.01
      scope.$apply()
      expect(scope.run.damages_as_billed.motor_bend).toEqual(jasmine.objectContaining({amount: 111, description: 'Motor bend over 2.0', original_amount_in_cents:111}))

    it "should remove motor bend damages as expected", ->
      scope.run.motor_bend_as_billed = 2.01
      scope.$apply()
      expect(scope.run.damages_as_billed.motor_bend).toEqual(jasmine.objectContaining({amount: 111, description: 'Motor bend over 2.0'}))
      scope.run.motor_bend_as_billed = 1.01
      scope.$apply()
      expect(scope.run.damages_as_billed.motor_bend).toEqual({})

  describe "when the user changes rpm", ->
    message = jasmine.objectContaining({amount: 111, description: 'RPM over 70'})
    beforeEach ->
      expect(scope.run.damages_as_billed.rpm).toEqual(jasmine.objectContaining({amount:0, description:''}))

    it "should add rpm damages", ->
      scope.run.rpm_as_billed = 71
      scope.$apply()
      expect(scope.run.damages_as_billed.rpm).toEqual(message)

    it "should remove rpm damages as expected", ->
      scope.run.rpm_as_billed = 71
      scope.$apply()
      expect(scope.run.damages_as_billed.rpm).toEqual(message)
      scope.run.rpm_as_billed = 70
      scope.$apply()
      expect(scope.run.damages_as_billed.rpm).toEqual(jasmine.objectContaining({amount:0, description:''}))

  describe "when both rpm and motor bend has damages", ->
    describe "when motor bend is more expensive", ->
      beforeEach ->
        scope.invoice.client.pricing.motor_bend['2.0'].amount = 222
        scope.invoice.client.pricing.rpm['70'].amount = 111
        scope.$apply()
        scope.run.motor_bend_as_billed = 2.38
        scope.run.rpm_as_billed = 71
        scope.$apply()
      it 'should select the greater amount', ->
        expect( scope.run.damages_as_billed.motor_bend ).toEqual(jasmine.objectContaining({amount: 222, description: 'Motor bend over 2.0'}))

    describe "when rpm is more expensive", ->
      beforeEach ->
        scope.invoice.client.pricing.motor_bend['2.0'].amount = 111
        scope.invoice.client.pricing.rpm['70'].amount = 222
        scope.$apply()
        scope.run.motor_bend_as_billed = 2.38
        scope.run.rpm_as_billed = 71
        scope.$apply()
      it 'should select the greater amount', ->
        expect( scope.run.damages_as_billed.motor_bend ).toEqual(jasmine.objectContaining({amount: 222, description: 'RPM over 70'}))

  describe "when the mud type is water", ->
    beforeEach ->
      scope.run.mud_type_as_billed = "Water Based Mud"
      scope.$apply()

    describe "when sand is above the threshold", ->
      beforeEach ->
        scope.run.sand_as_billed = 1.1
        scope.$apply()

      it "should charge a flat fee", ->
        expect( scope.run.damages_as_billed.sand ).toEqual(jasmine.objectContaining({amount: 333, description: 'Sand over 1'}))

    describe "when sand is above the chlorides", ->
      beforeEach ->
        scope.run.chlorides_as_billed = 1001
        scope.$apply()

      it "should charge a flat fee", ->
        expect( scope.run.damages_as_billed.chlorides ).toEqual(jasmine.objectContaining({amount: 444, description: 'Chlorides over 1000'}))

    describe "when sand and chlorides are above the thresholds", ->
      beforeEach ->
        scope.run.chlorides_as_billed = 10001
        scope.run.sand_as_billed = 1.1
        scope.$apply()

      it "should have two flat fees", ->
        expect( scope.run.damages_as_billed.sand ).toEqual(jasmine.objectContaining({amount: 333, description: 'Sand over 1'}))
        expect( scope.run.damages_as_billed.chlorides ).toEqual(jasmine.objectContaining({amount: 444, description: 'Chlorides over 1000'}))

  describe "when an agitator is present", ->
    beforeEach ->
      scope.run.agitator_distance_as_billed = 0.1
      scope.$apply()

    it "should bill for its presence", ->
      expect( scope.run.damages_as_billed.agitator_distance ).toEqual(jasmine.objectContaining({amount: 123, description: 'Agitator present'}))

    describe "and it is more than the first threshold", ->
      beforeEach ->
        scope.run.agitator_distance_as_billed = 10.1
        scope.$apply()

      it "should bill for excessive use", ->
        expect( scope.run.damages_as_billed.agitator_distance ).toEqual(jasmine.objectContaining({amount: 222, description: 'Agitator distance over 10'}))

  describe "max temperature", ->
    it "should not incur any damages", ->
      scope.run.max_temperature_as_billed = 0
      scope.$apply()
      expect( scope.run.damages_as_billed.max_temperature.amount ).toEqual(0)

    it "should not incur any damages", ->
      scope.run.max_temperature_as_billed = 310
      scope.$apply()
      expect( scope.run.damages_as_billed.max_temperature.amount ).toEqual(0)

    it "should set to be above 311", ->
      scope.run.max_temperature_as_billed = 311.1
      scope.$apply()
      expect( scope.run.damages_as_billed.max_temperature ).toEqual(jasmine.objectContaining({amount: 3000000, description: "Temperature over 311"}))

    it "should set to be above 319", ->
      scope.run.max_temperature_as_billed = 319.1
      scope.$apply()
      expect( scope.run.damages_as_billed.max_temperature ).toEqual(jasmine.objectContaining({amount: 5500000, description: "Temperature over 319"}))

  describe "max shock", ->
    it "should not incur any damages", ->
      scope.run.max_shock_as_billed = 0
      scope.$apply()
      expect( scope.run.damages_as_billed.max_shock.amount ).toBe(0)

    it "should not incur any damages", ->
      scope.run.max_shock_as_billed = 6
      scope.$apply()
      expect( scope.run.damages_as_billed.max_shock.amount ).toBe(0)

    it "should incur the correct amount of damages", ->
      scope.run.max_shock_as_billed = 6.1
      scope.$apply()
      expect( scope.run.damages_as_billed.max_shock ).toEqual(jasmine.objectContaining({amount: 3000000, description: "Shock over 6"}))

    it "should incur the correct amount of damages", ->
      scope.run.max_shock_as_billed = 9
      scope.$apply()
      expect( scope.run.damages_as_billed.max_shock ).toEqual(jasmine.objectContaining({amount: 3000000, description: "Shock over 6"}))

    it "should incur the correct amount of damages", ->
      scope.run.max_shock_as_billed = 9.1
      scope.$apply()
      expect( scope.run.damages_as_billed.max_shock ).toEqual(jasmine.objectContaining({amount: 5500000, description: "Shock over 9"}))

  describe "max vibe", ->
    it "should not incur any damages", ->
      scope.run.max_vibe_as_billed = 0
      scope.$apply()
      expect( scope.run.damages_as_billed.max_vibe.amount ).toBe(0)

    it "should not incur any damages", ->
      scope.run.max_vibe_as_billed = 6
      scope.$apply()
      expect( scope.run.damages_as_billed.max_vibe.amount ).toBe(0)

    it "should incur the correct amount of damages", ->
      scope.run.max_vibe_as_billed = 6.1
      scope.$apply()
      expect( scope.run.damages_as_billed.max_vibe ).toEqual(jasmine.objectContaining({amount: 3000000, description: "Vibe over 6"}))

    it "should incur the correct amount of damages", ->
      scope.run.max_vibe_as_billed = 9
      scope.$apply()
      expect( scope.run.damages_as_billed.max_vibe ).toEqual(jasmine.objectContaining({amount: 3000000, description: "Vibe over 6"}))

    it "should incur the correct amount of damages", ->
      scope.run.max_vibe_as_billed = 9.1
      scope.$apply()
      expect( scope.run.damages_as_billed.max_vibe ).toEqual(jasmine.objectContaining({amount: 5500000, description: "Vibe over 9"}))

  describe "shock warnings", ->
    it "should not incur any damages", ->
      scope.run.shock_warnings_as_billed = 0
      scope.$apply()
      expect( scope.run.damages_as_billed.shock_warnings.amount ).toBe(0)

    it "should not incur any damages", ->
      scope.run.shock_warnings_as_billed = 1000
      scope.$apply()
      expect( scope.run.damages_as_billed.shock_warnings.amount ).toBe(0)

    it "should incur the right amount of damages", ->
      scope.run.shock_warnings_as_billed = 1001
      scope.$apply()
      expect( scope.run.damages_as_billed.shock_warnings).toEqual(jasmine.objectContaining({amount:100000, description: "Shock warnings over 1000"}))

    it "should incur the right amount of damages", ->
      scope.run.shock_warnings_as_billed = 2000
      scope.$apply()
      expect( scope.run.damages_as_billed.shock_warnings).toEqual(jasmine.objectContaining({amount:100000, description: "Shock warnings over 1000"}))

    it "should incur the right amount of damages", ->
      scope.run.shock_warnings_as_billed = 2001
      scope.$apply()
      expect( scope.run.damages_as_billed.shock_warnings).toEqual(jasmine.objectContaining({amount:200000, description: "Shock warnings over 2000"}))
