// تحميل ملف اللغة وتحديث الواجهة
async function loadLanguage(lang) {
    try {
        const response = await fetch(`../locales/${lang}.json`);
        const translations = await response.json();
        
        // تحديث اتجاه اللوحة والنصوص
        document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
        document.documentElement.lang = lang;
        
        if (translations.wallet) {
            document.getElementById('walletTitle').innerText = translations.wallet.title;
            document.getElementById('rateNotice').innerText = translations.wallet.rate;
            document.getElementById('buyBtn').innerText = translations.wallet.buy_button;
        }
    } catch (error) {
        console.error('Error loading language file:', error);
    }
}

// الاستماع لتغيير اللغة من القائمة
document.addEventListener('DOMContentLoaded', () => {
    const langSelect = document.getElementById('langSelect');
    if (langSelect) {
        langSelect.addEventListener('change', (e) => {
            loadLanguage(e.target.value);
        });
    }
});
