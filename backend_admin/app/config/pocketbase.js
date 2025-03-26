const PocketBase = require('pocketbase').default;
require('dotenv').config();

const pb = new PocketBase(process.env.POCKETBASE_URL);

module.exports = pb;
