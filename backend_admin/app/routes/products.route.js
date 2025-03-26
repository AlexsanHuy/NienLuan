const express = require('express');
const router = express.Router();
const productController = require('../controllers/products.controller');
const upload = require('../middleware/upload');

router.get('/products', productController.getProducts);
router.get('/products/:id', productController.getProductById);
router.post('/products/sale/:id', productController.setProductsOnSale);
router.post('/products/unsale/:id', productController.setProductsUnsale);
router.post('/products/discount/:id', productController.setDiscountProductsOnSale);
router.post('/products', upload.single('image'), productController.createProduct);
router.put('/products/:id', upload.single('image'), productController.updateProduct);
router.delete('/products/:id', productController.deleteProduct);

module.exports = router;
