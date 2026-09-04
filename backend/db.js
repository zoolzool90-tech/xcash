const { Pool } = require('pg');
require('dotenv').config();

// إعداد الاتصال بقاعدة البيانات PostgreSQL
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

pool.on('connect', () => {
    console.log('تم الاتصال بقاعدة بيانات X Cash بنجاح');
});

module.exports = {
    query: (text, params) => pool.query(text, params),
};
