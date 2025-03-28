const pb = require('../config/pocketbase');

exports.getFeedback = async (req, res) => {
    try {
        const feedback = await pb.collection('feedbacks').getFullList({
            expand: 'feedback_uid'
        });
        res.status(200).json(feedback);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

exports.deleteFeedback = async (req, res) => {
    try {
        await pb.collection('feedbacks').delete(req.params.id);
        res.status(200).json({ message: 'Feedback deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

