const pb = require('../config/pocketbase');

exports.getOrders = async (req, res) => {
    try {
        const orders = await pb.collection('order_list').getFullList();
        res.status(200).json(orders);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.getOrderById = async (req, res) => {
    try {
        const order = await pb.collection('order_list').getOne(req.params.id);
        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.updateStatusOrder = async (req, res) => {
    try {
        const order = await pb.collection('order_list').update(req.params.id, req.body);
        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.detailOrder = async (req, res) => {
    try {
        const order = await pb.collection('order_detail').getFullList(1, {
            filter: `oid= "${req.params.id}"`
        });
        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.deleteOrder = async (req, res) => {
    try {
        const order = await pb.collection('order_list').delete(req.params.id);
        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};