// Add this CORS configuration after app creation:
  app.enableCors({
    origin: (origin, callback) => {
      if (!origin || process.env.NODE_ENV === 'development') {
        return callback(null, true);
      }
      callback(null, true);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS', 'HEAD'],
    allowedHeaders: [
      'Content-Type',
      'Authorization',
      'X-Requested-With',
      'Accept',
      'Origin',
      'x-tenant-id',
      'x-user-id',
      'x-correlation-id',
      'x-request-id',
    ],
  });
