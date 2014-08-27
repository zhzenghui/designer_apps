json.array!(@softwares) do |software|
  json.extract! software, :id, :app_id, :app_name, :app_spell
  json.url software_url(software, format: :json)
end
