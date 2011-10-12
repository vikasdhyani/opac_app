class OpacSettings < Settingslogic
  source "#{Rails.root}/config/opac.yml"
  namespace Rails.env
end
