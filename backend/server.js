const express = require('express');
const cors = require('cors');
require('dotenv').config();
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// مسار تجريبي للتحقق من حالة السيرفر
app.get('/api/health', (req, res) => {
    res.json({
        status: 'online',
        system: 'X Cash Ecosystem',
        rate: '1 USD = 10 X Cash'
    });
});

// مسار جلب رصيد محفظة المستخدم
app.get('/api/wallet/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const result = await db.query('SELECT balance_x_cash FROM wallets WHERE user_id = $1', [userId]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'المحفظة غير موجودة' });
        }
        res.json({ user_id: userId, balance: result.rows[0].balance_x_cash });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'حدث خطأ في الاتصال بقاعدة البيانات' });
    }
});

// مسار شراء أو شحن رصيد X Cash (1 USD = 10 X Cash)
app.post('/api/wallet/topup', async (req, res) => {
    const { userId, amountUsd } = req.body;
    
    if (!amountUsd || amountUsd <= 0) {
        return res.status(400).json({ error: 'يرجى إدخال مبلغ صحيح' });
    }

    const xCashAdded = amountUsd * 10;

    try {
        const updateWallet = await db.query(
            'UPDATE wallets SET balance_x_cash = balance_x_cash + $1, updated_at = NOW() WHERE user_id = $2 RETURNING balance_x_cash',
            [xCashAdded, userId]
        );

        if (updateWallet.rows.length === 0) {
            return res.status(404).json({ error: 'المستخدم غير موجود' });
        }

        res.json({
            message: 'تم شحن المحفظة بنجاح',
            added_x_cash: xCashAdded,
            new_balance: updateWallet.rows[0].balance_x_cash
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'فشلت عملية الشحن' });
    }
});

app.listen(PORT, () => {
    console.log(`X Cash Server running on port ${PORT}`);
});
