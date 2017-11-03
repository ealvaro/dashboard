$scope = undefined;
scope = undefined;
$rootScope = undefined;
$compile = undefined;
$httpBackend = undefined;
elem = undefined;
$http = undefined
now = new Date()
tools = [{
           tool_type: {
                        name: "Pulser Driver"
                      },
           cache: {
                    time: now.toString()
                  }

         },
         {
           tool_type: {
                        name: "Dual Gamma"
                      },
           cache: {
                    time: now.toString()
                  }

         },
         {
           tool_type: {
                        name: "Dual Gamma"
                      },
           cache: {
                    time: now.toString()
                  }
         }]


describe 'tools directive', ->

  beforeEach module( 'erdos' )
  beforeEach module( 'templates' )
  beforeEach inject( (_$httpBackend_, _$compile_, _$rootScope_) ->
    $httpBackend = _$httpBackend_
    $scope = _$rootScope_.$new()
    $compile = _$compile_;
    elem = $compile( "<tools></tools>" )($scope)
    scope = elem.scope()
    $httpBackend.whenGET(/^\/v750\/tools/).respond( tools )
    $httpBackend.whenGET("/push/current_user").respond( {} )
    scope.$apply();
  )

  describe 'after tools are set', ->
    beforeEach ->
      scope.tools = tools
      scope.$apply()

    it 'should set filter types correctly', ->
      expect( scope.tools ).toBe( tools )
      scope.setFilterTypes()
      expect( scope.filter_types ).toContain("Pulser Driver")
      expect( scope.filter_types ).toContain("Dual Gamma")

    describe 'after clicking details', ->
      pending 'this code changed a lot'

      beforeEach ->
        details_anchor = elem.find( 'tool-cog div a' )[0]
        details_anchor.click() if details_anchor.id == "details_button"

      it 'should show details fields', ->
        expect( elem.html() ).toContain( "Board Serial #" )
        expect( elem.html() ).toContain( "Asset #" )
        expect( elem.html() ).toContain( "Board Serial #" )
        expect( elem.html() ).toContain( "Asset #" )
        expect( elem.html() ).toContain( "Chassis Serial Number" )
        expect( elem.html() ).toContain( "Secondary Asset Numbers" )
        expect( elem.html() ).toContain( "Memory Usage Level" )
        expect( elem.html() ).toContain( "User Email" )
        expect( elem.html() ).toContain( "Region" )
        expect( elem.html() ).toContain( "Notes" )
        expect( elem.html() ).toContain( "Job #" )
        expect( elem.html() ).toContain( "Run #" )
        expect( elem.html() ).toContain( "Reporter Context" )
        expect( elem.html() ).toContain( "Reporter Version" )
        expect( elem.html() ).toContain( "Name" )
        expect( elem.html() ).toContain( "UID" )
        expect( elem.html() ).toContain( "Hardware Version" )
        expect( elem.html() ).toContain( "Board Firmware Version" )
        expect( elem.html() ).toContain( "Last Connected" )
        expect( elem.html() ).toContain( "Max Temperature" )
        expect( elem.html() ).toContain( "Max Shock" )

      describe 'after clicking hide', ->
        beforeEach ->
          for anchor in elem.find( 'tbody a' )
            anchor.click() if anchor.id == "hide_details"

        it 'should hide the details', ->
          expect( elem.find( 'tbody dl' ).length ).toBe( 0 )
