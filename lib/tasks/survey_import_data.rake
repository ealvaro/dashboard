namespace :tracker do

  desc 'create random survey import data'
  task :survey_import_data do

    def random_decimal
      (200.0 - 5.0) * rand()
    end

    def ran_between(a,b)
      rand(a..b) + random_decimal
    end

    100.times do |i|
      next if i == 0
      depth = i * 110
      vals = [depth, ran_between(80,90), ran_between(200,250), ran_between(50, 60)] + 6.times.map { random_decimal }

      $stdout.write vals.join(",")
      $stdout.flush
      $stdout.write("\n")
    end

  end

end
