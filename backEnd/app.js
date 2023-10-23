const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
require('dotenv').config();
const app = express();

const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const User = require('./models/User');
const cors = require('cors');
// passport.use(
//   new LocalStrategy((username, password, done) => {
//     User.findOne({ username }, (err, user) => {
//       if (err) return done(err);
//       if (!user || !user.comparePassword(password)) {
//         return done(null, false);
//       }
//       return done(null, user);
//     });
//   })
// );

// MongoDB Connection
mongoose.connect('mongodb+srv://adityadubey:adityadubey@cluster0.bzu5sg9.mongodb.net/', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
mongoose.connection.on('error', (err) => {
  console.error('MongoDB connection error:', err);
});
let corsOptions = {
  origin: [ 'http://localhost:3000' ]
};
app.use(cors())
// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Routes
const indexRoutes = require('./routes/index');
const authRoutes = require('./routes/auth');

app.use('/api', indexRoutes);
app.use('/api/auth', authRoutes);
app.use((err, req, res, next) => {
    err.statusCode = err.statusCode || 500;
    err.status = err.status || 'error';
  
    res.status(err.statusCode).json({
      status: err.status,
      message: err.message,
      errorBody : err.errorBody,
    });
  });
// Start the server
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});