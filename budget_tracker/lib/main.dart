import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/expense.dart';

void main() {
  runApp(BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BudgetHomePage(),
    );
  }
}

class BudgetHomePage extends StatefulWidget {
  @override
  _BudgetHomePageState createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  final List<Expense> _expenses = [];
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  void _addExpense() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);
    if (title.isEmpty || amount == null || amount <= 0) {
      return;
    }
    final newExpense = Expense(
      title: title,
      amount: amount,
      date: DateTime.now(),
    );
    setState(() {
      _expenses.add(newExpense);
    });
    _titleController.clear();
    _amountController.clear();
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                  ),
                  ElevatedButton(
                    child: Text('Add Expense'),
                    onPressed: _addExpense,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: Key(_expenses[index].hashCode.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteExpense(index);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(_expenses[index].title),
                      subtitle: Text(
                        '\$${_expenses[index].amount.toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        DateFormat('yyyy-MM-dd').format(_expenses[index].date),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
