Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins [ ENV.fetch("FRONTEND_HOST"), "http://localhost:5173" ]
    resource "/api/v1/restaurants/*",
    headers: :any,
    methods: [ :get, :options, :head ],
    credentials: true
  end
end
