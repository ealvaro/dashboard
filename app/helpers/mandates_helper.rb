module MandatesHelper

  def pretty_occurences(mandate)
    case mandate.occurences
    when 1
      "Once"
    when -1
      "Always"
    else
      mandate.occurences
    end
  end
end
