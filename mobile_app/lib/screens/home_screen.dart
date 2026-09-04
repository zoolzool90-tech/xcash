import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../constants/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _balance = 0.0;
  bool _isLoading = true;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    setState(() {
      _isLoading = true;
    });
    final data = await ApiService.getWalletBalance(1);
    if (data.containsKey('balance')) {
      setState(() {
        _balance = (data['balance'] as num).toDouble();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleTopUp() async {
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final result = await ApiService.topUpWallet(1, amount);
    if (result.containsKey('newBalance')) {
      setState(() {
        _balance = (result['newBalance'] as num).toDouble();
      });
      _amountController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم شحن الرصيد بنجاح!')),
      );
    }
  }

  void _showTopUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: XCashTheme.darkCard,
        title: const Text('شحن رصيد X Cash', style: TextStyle(color: XCashTheme.primaryGold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('سعر الصرف: 1 USD = 10 X Cash', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'المبلغ بـ USD',
                labelStyle: TextStyle(color: XCashTheme.primaryGold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: XCashTheme.primaryGold)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: XCashTheme.primaryGold)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _handleTopUp,
            child: const Text('شحن الآن'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محفظة X Cash'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchBalance,
        color: XCashTheme.primaryGold,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // كارت المحفظة الذهبي
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C2C2C), Color(0xFF1E1E1E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: XCashTheme.primaryGold, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: XCashTheme.primaryGold.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'الرصيد الحالي',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    _isLoading
                        ? const CircularProgressIndicator(color: XCashTheme.primaryGold)
                        : Text(
                            '$_balance X CASH',
                            style: const TextStyle(
                              color: XCashTheme.primaryGold,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _showTopUpDialog,
                icon: const Icon(Icons.add),
                label: const Text('شحن المحفظة'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
