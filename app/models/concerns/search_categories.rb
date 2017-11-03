module SearchCategories
  extend ActiveSupport::Concern

  module ClassMethods
    def is_job_number? value
      !!(value =~ /[a-zA-Z]{2}[-]\d{6}/i)
    end

    def is_date? value
      value = date_filter(value)
      !!(value =~ /\d{4}(-|\/)\d{1,2}(-|\/)\d{1,2}/)
    end

    def date_filter value
      if (value =~ /\d{1,2}(-|\/)\d{1,2}(-|\/)\d{4}/)
        array = value.split('/')
        value = "#{array[2]}/#{array[0]}/#{array[1]}"
      else
        value
      end
    end
  end
end
