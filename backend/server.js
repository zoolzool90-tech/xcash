const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// إعدادات الوسائط والتشفير
app.use(cors());
app.use(express.json());

// مسار تجريبي للتحقق من عمل الخادم
app.get('/api/health', (req, res) => {
    res.json({
        status: 'online',
        system: 'X Cash Ecosystem',
        rate: '1 USD = 10 X Cash'
    });
});

// مسار حساب تحويل العملة (1 دولار = 10 X Cash)
app.post('/api/convert', (req, res) => {
    const { amount_usd } = req.body;
    if (!amount_usd || amount_usd <= 0) {
        return res.status(400).json({ error: 'يرجى إدخال مبلغ صحيح بالدولار' });
    }
    
    const x_cash_amount = amount_usd * 10;
    res.json({
        amount_usd: amount_usd,
        x_cash: x_cash_amount,
        message: `تم تحويل $${amount_usd} إلى ${x_cash_amount} X Cash بنجاح`
    });
});

// تشغيل الخادم
app.listen(PORT, () => {
    console.log(`X Cash Server running on port ${PORT}`);
});
