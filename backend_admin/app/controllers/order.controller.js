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

exports.countQuantityOrder = async (req, res) => {
    try {
        const response = await pb.collection("order_detail").getFullList({
            expand: "pid",
        });

        const productCount = response.reduce((acc, item) => {
            const productName = item.expand?.pid?.name || "Không xác định";
            
            if (!acc[productName]) {
                acc[productName] = { name: productName, totalQuantity: 0 };
            }

            acc[productName].totalQuantity += item.quantity;
            return acc;
        }, {});

        const result = Object.values(productCount).sort((a, b) => b.totalQuantity - a.totalQuantity);

        res.status(200).json(result);
    } catch (error) {
        console.error("Lỗi khi truy vấn PocketBase:", error);
        res.status(500).json({ message: "Lỗi server: " + error.message });
    }
};

