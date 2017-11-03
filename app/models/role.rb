class Role
  def self.all
    ["Admin", "Installations", "Mandates", "Firmware Updates", "Software",
     "Support", "Tools", "Receivers", "Superuser", "Survey", "Billing",
     "Report Requests", "Client Info", "Directional Drilling",
     "Quality Control"] +
      lconfig_roles + email_notifications
  end

  def self.lconfig_roles
    ["LConfig Admin", "LConfig Service", "LConfig Field", "LConfig Debug"]
  end

  def self.email_notifications
    ["Email Crossover Events"]
  end
end
