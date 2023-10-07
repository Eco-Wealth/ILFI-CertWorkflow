const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Middleware for parsing JSON and handling CORS
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

// Define routes
const certificationRoutes = require('./routes/certification');
app.use('/api/certification', certificationRoutes);

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
