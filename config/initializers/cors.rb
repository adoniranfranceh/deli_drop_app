Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins [ ENV.fetch("FRONTEND_HOST"), "http://localhost:5173" ]
    resource "/api/v1/*",
    headers: :any,
    methods: [ :get, :post, :patch, :options, :head ],
    credentials: true

    resource "/cable",
    headers: :any,
    methods: [ :get, :post, :options ],
    credentials: true
  end
end
