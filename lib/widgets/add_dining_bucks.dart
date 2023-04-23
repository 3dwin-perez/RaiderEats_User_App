import 'package:flutter/material.dart';
import 'package:raidereats_users_app/widgets/simple_app_bar.dart';

class AddDiningBucks extends StatefulWidget {
  const AddDiningBucks({Key? key}) : super(key: key);

  @override
  _AddDiningBucksState createState() => _AddDiningBucksState();
}

class _AddDiningBucksState extends State<AddDiningBucks> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double _diningBucks = 50; // Example amount of dining bucks
  bool _isProcessing = false;

  void _processDiningBucks() async {
    setState(() {
      _isProcessing = true;
    });
    // Get the amount to spend
    double amountToSpend = double.tryParse(_amountController.text) ?? 0;
    // Process the dining bucks
    await Future.delayed(Duration(seconds: 2)); // Simulate processing time
    double processingAmount = amountToSpend; // Example processing amount
    double newDiningBucks = _diningBucks - processingAmount;
    setState(() {
      _diningBucks = newDiningBucks;
      _isProcessing = false;
    });
    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully spent dining bucks.'),
        backgroundColor: Colors.green,
      ),
    );
    // Clear the fields
    _idController.clear();
    _amountController.clear();
  }

  void _processCreditCard() async {
    // Process the credit card payment
    await Future.delayed(Duration(seconds: 2)); // Simulate processing time
    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully processed credit card payment.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Add Dining Bucks',
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Dining Bucks: \$${_diningBucks.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: 'Enter ID Number',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Enter Amount to Spend',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessing ? null : _processDiningBucks,
              child: _isProcessing ? CircularProgressIndicator() : Text('Spend Dining Bucks'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Amount left after processing: \$${_diningBucks.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _processCreditCard,
              child: Text('Pay with Credit/Debit Card'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}