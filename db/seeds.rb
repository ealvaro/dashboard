ToolType.where(name: 'Dual Gamma').first_or_create(klass: 'DualGamma', description: 'Dual Gamma Controller', number: 0)
ToolType.where(name: 'Pulser Driver').first_or_create(klass: 'PulserDriver', description: 'Single/Dual Solenoid Driver', number: 1)
ToolType.where(name: 'Sensor Interface').first_or_create(klass: 'SensorInterface', description: 'MPU/OM Sensor Interface', number: 2)
ToolType.where(name: 'EM').first_or_create(klass: 'EM', description: 'EM MWD Controller', number: 3)
ToolType.where(name: 'Receiver').first_or_create(klass: 'Receiver', description: 'Receiver', number: 4)
ToolType.where(name: 'Gamma').first_or_create(klass: 'Gamma', description: 'Gamma Dumb Tool', number: 5)
ToolType.where(name: 'Dashboard').first_or_create(klass: 'Dashboard', description: 'Dashboard', number: 6)
ToolType.where(name: 'Smart Battery').first_or_create(klass: 'SmartBattery', description: 'Smart Battery', number: 7)
ToolType.where(name: 'Dual Gamma Lite').first_or_create(klass: 'DualGammaLite', description: 'Dual Gamma Lite', number: 8)
ToolType.where(name: 'Smart Lower End').first_or_create(klass: 'SmartLowerEnd', description: 'Smart Lower End', number: 9)
ToolType.where(name: 'Orientation Module').first_or_create(klass: 'OrientationModule', description: 'Orientation Module', number: 10)
ToolType.where(name: 'Pigtail').first_or_create(klass: 'Pigtail', description: 'Pigtail', number: 11)
ToolType.where(name: 'Snubber').first_or_create(klass: 'Snubber', description: 'Snubber', number: 12)
ToolType.where(name: 'Solenoid').first_or_create(klass: 'Solenoid', description: 'Solenoid', number: 13)
ToolType.where(name: 'Accel').first_or_create(klass: 'Accel', description: 'Accel', number: 14)
ToolType.where(name: 'Mag').first_or_create(klass: 'Mag', description: 'Mag', number: 15)
ToolType.where(name: 'Temp').first_or_create(klass: 'Temp', description: 'Temp', number: 16)
ToolType.where(name: 'BTR Control').first_or_create(klass: 'BtrControl', description: 'BenchTree Receiver Control', number: 17)
ToolType.where(name: 'BTR Monitor').first_or_create(klass: 'BtrMonitor', description: 'BenchTree Receiver Monitor', number: 18)
ToolType.where(name: 'LRx').first_or_create(klass: 'LeamReceiver', description: 'Leam Receiver', number: 19)
ToolType.where(name: 'APS EM Rx').first_or_create(klass: 'EmReceiver', description: 'APS EM Receiver', number: 20)

User.create name: 'Josh', email:'joshua.wolfe@erdosmiller.com', password: 'fakepass', password_confirmation: 'fakepass', roles: Role.all
User.create name: 'Ashley Herron', email:'ashley.herron@erdosmiller.com', password: 'em1mosfet', password_confirmation: 'em1mosfet', roles: Role.all
User.create name: 'Paul', email:'paul.nesbitt@erdosmiller.com', password: '123', password_confirmation: '123', roles: Role.all
User.create name: 'Matt', email:'matthew.miller@erdosmiller.com', password: '123456', password_confirmation: '123456', roles: Role.all

dpc = DefaultPricingScheme.new()
dpc.max_temperature = { '311' => { 'amount' => 30000_00, 'description' => "Temperature over 311" }, '319' => { 'amount' => 55000_00, 'description' => "Temperature over 319" } }
dpc.max_shock = { '6.0' => { 'amount' => 30000_00, 'description' => "Shock over 6" }, '9.0' => { 'amount' => 55000_00, 'description' => "Shock over 9" } }
dpc.max_vibe = { '6.0' => { 'amount' => 30000_00, 'description' => "Vibe over 6" }, '9.0' => { 'amount' => 55000_00, 'description' => "Vibe over 9" } }
dpc.shock_warnings = { '1000' => { 'amount' => 10000_00, 'description' => "Shock warnings over 1000" }, '2000' => { 'amount' => 20000_00, 'description' => "Shock warnings over 2000" } }
dpc.motor_bend =  { '2.0' => { 'amount' => 111, 'description' => "Motor bend over 2.0" } }
dpc.rpm = { '70' => { 'amount' => 111, 'description' => "RPM over 70" } }
dpc.agitator_distance = { '0.0' => { 'amount' => 123, 'description' => "Agitator present" }, '10.0' => { 'amount' => 222, 'description' => "Agitator distance over 10" } }
dpc.mud_type =  { 'water_based_mud' => { 'sand' =>  { '1.0' => { 'amount' => 333, 'description' => "Sand over 1" } }, 'chlorides' =>  { '1000' => { 'amount' => 444, 'description' => "Chlorides over 1000" } } } }
dpc.dd_hours = { '24.0' => { 'amount' => 555, 'description' => "DD hours over 24" }, '100.0' => { 'amount' => 666, 'description' => "DD hours over 100" } }
dpc.mwd_hours =  { '24.0' => { 'amount' => 555, 'description' => "MWD hours over 24" }, '100.0' => { 'amount' => 666, 'description' => "MWD hours over 100" } }
dpc.save!
