const pb = require('../config/pocketbase');

exports.getUsers = async (req, res) => {
    const users = await pb.collection('users').getFullList();
    res.status(200).json(users);
};

exports.getUserById = async (req, res) => {
    const user = await pb.collection('users').getOne(req.params.id);
    res.status(200).json(user);
};

exports.deleteUser = async (req, res) => {
    const user = await pb.collection('users').delete(req.params.id);
    res.status(200).json(user);
};

