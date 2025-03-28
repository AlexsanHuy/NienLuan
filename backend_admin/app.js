const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();

app.use(cors());
app.use(bodyParser.json());

app.get('/', (req, res) => {
    res.send('Hello Admin');
});

const categoriesRoutes = require('./app/routes/category.route');
app.use('/api', categoriesRoutes);

const productsRoutes = require('./app/routes/products.route');
app.use('/api', productsRoutes);

const ordersRoutes = require('./app/routes/orders.route');
app.use('/api', ordersRoutes);

const usersRoutes = require('./app/routes/users.route');
app.use('/api', usersRoutes);

const feedbackRoutes = require('./app/routes/feedback.route');
app.use('/api', feedbackRoutes);

app.use((req, res, next) => {
    next(new ApiError(404, 'Not found'));
});

app.use((err, req, res, next) => {
    err.statusCode = err.statusCode || 500;
    err.message = err.message || 'Internal Server Error';
});
module.exports = app;
