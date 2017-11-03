FactoryGirl.define do
  factory :pricing_scheme do
    association(:client)
    max_temperature   ({ '311' => { 'amount' => 30000_00, 'description' => "Temperature over 311" }, '319' => { 'amount' => 55000_00, 'description' => "Temperature over 319" } })
    max_shock         ({ '6.0' => { 'amount' => 30000_00, 'description' => "Shock over 6" }, '9.0' => { 'amount' => 55000_00, 'description' => "Shock over 9" } })
    max_vibe          ({ '6.0' => { 'amount' => 30000_00, 'description' => "Vibe over 6" }, '9.0' => { 'amount' => 55000_00, 'description' => "Vibe over 9" } })
    shock_warnings    ({ '1000' => { 'amount' => 10000_00, 'description' => "Shock warnings over 1000" }, '2000' => { 'amount' => 20000_00, 'description' => "Shock warnings over 2000" } })
    motor_bend        ({ '2.0' => { 'amount' => 111, 'description' => "Motor bend over 2.0" } })
    rpm               ({ '70' => { 'amount' => 111, 'description' => "RPM over 70" } })
    agitator_distance ({ '0.0' => { 'amount' => 123, 'description' => "Agitator present" }, '10.0' => { 'amount' => 222, 'description' => "Agitator distance over 10" } })
    mud_type          ({ 'water_based_mud' => { 'sand' =>  { '1.0' => { 'amount' => 333, 'description' => "Sand over 1" } }, 'chlorides' =>  { '1000' => { 'amount' => 444, 'description' => "Chlorides over 1000" } } } })
    dd_hours          ({ '24.0' => { 'amount' => 555, 'description' => "DD hours over 24" }, '100.0' => { 'amount' => 666, 'description' => "DD hours over 100" } })
    mwd_hours         ({ '24.0' => { 'amount' => 555, 'description' => "MWD hours over 24" }, '100.0' => { 'amount' => 666, 'description' => "MWD hours over 100" } })
  end
end
