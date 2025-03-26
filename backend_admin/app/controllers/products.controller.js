const pb = require('../config/pocketbase');

exports.getProducts = async (req, res) => {
    try {
        const products = await pb.collection('products').getFullList();
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.getProductById = async (req, res) => {
    try {
        const product = await pb.collection('products').getOne(req.params.id);
        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.createProduct = async (req, res) => {
    try {
        const data = {
            name: req.body.name,
            price: req.body.price,
            description: req.body.description,
            category: req.body.category,
            sale: false,
            sale_value: 0,
        }

        if (req.file) {
            data.image = new Blob([req.file.buffer], { type: req.file.mimetype });
        }

        const product = await pb.collection('products').create(data);
        res.status(201).json(product);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.updateProduct = async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ message: 'Image is required' });
        }

        const image = new Blob([req.file.buffer], { type: req.file.mimetype });
        
        const product = await pb.collection('products').update(req.params.id, {
            name: req.body.name,
            price: req.body.price,
            description: req.body.description,
            category: req.body.category,
            image: image,
        });

        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.deleteProduct = async (req, res) => {
    try {
        await pb.collection('products').delete(req.params.id);
        res.status(200).json({ message: 'Product deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.setProductsOnSale = async (req, res) => {
    try {
        const product = await pb.collection('products').update(req.params.id,{
            sale: true,
        });
        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.setProductsUnsale = async (req, res) => {
    try {
        const product = await pb.collection('products').update(req.params.id, {
            sale: false,
        });
        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.setDiscountProductsOnSale = async (req, res) => {
    try {
        const { sale_value } = req.body;
        if (sale_value === undefined || isNaN(sale_value)) {
            return res.status(400).json({ message: "Giá trị giảm giá không hợp lệ" });
        }

        const product = await pb.collection('products').update(req.params.id, { sale_value });
        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};













