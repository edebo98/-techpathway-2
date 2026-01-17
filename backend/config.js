module.exports = {
  port: process.env.PORT || 8080,
  corsOrigins: [
    'http://localhost:3000',
    'http://techpathway-frontend-alb-2090297865.us-east-1.elb.amazonaws.com',
    '*'
  ]
};