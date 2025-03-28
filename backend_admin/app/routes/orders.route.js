const express = require('express');
const router = express.Router();
const orderController = require('../controllers/order.controller');

router.get('/orders', orderController.getOrders);
router.get('/orders/:id', orderController.getOrderById);
router.put('/orders/status/:id', orderController.updateStatusOrder);
router.delete('/orders/:id', orderController.deleteOrder);
router.get('/orders/count/quantity', orderController.countQuantityOrder);
router.get('/orders/detail/:id', orderController.detailOrder);

module.exports = router;
