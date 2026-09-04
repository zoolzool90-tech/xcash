const API_BASE_URL = 'http://localhost:5000/api';

// تحميل ملف اللغة وتحديث الواجهة والاتجاهات
async function loadLanguage(lang) {
    try {
        const response = await fetch(`../locales/${lang}.json`);
        const translations = await response.json();
        
        document.documentElement.dir = (lang === 'ar') ? 'rtl' : 'ltr';
        document.documentElement.lang = lang;
        
        if (translations.wallet) {
            document.getElementById('walletTitle').innerText = translations.wallet.title;
            document.getElementById('rateNotice').innerText = translations.wallet.rate;
            document.getElementById('buyBtn').innerText = translations.wallet.buy_button;
        }
    } catch (error) {
        console.error('خطأ في تحميل ملف اللغة:', error);
    }
}

// جلب رصيد المحفظة من السيرفر
async function fetchWalletBalance(userId) {
    try {
        const response = await fetch(`${API_BASE_URL}/wallet/${userId}`);
        const data = await response.json();
        if (response.ok) {
            document.getElementById('balance').innerText = data.balance;
        }
    } catch (error) {
        console.error('خطأ في جلب رصيد المحفظة:', error);
    }
}

// الاستماع للفعاليات عند تحميل الصفحة
document.addEventListener('DOMContentLoaded', () => {
    const langSelect = document.getElementById('langSelect');
    if (langSelect) {
        langSelect.addEventListener('change', (e) => {
            loadLanguage(e.target.value);
        });
    }

    // تجربة جلب رصيد المستخدم رقم 1 كنموذج
    fetchWalletBalance(1);
});
