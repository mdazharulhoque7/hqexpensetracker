import 'package:flutter/material.dart';
import 'package:hqexpensetracker/widgets/charts/chart.dart';
import 'package:hqexpensetracker/widgets/expenses/expenses_list/expenses_list.dart';
import 'package:hqexpensetracker/models/expense.dart';
import 'package:hqexpensetracker/widgets/expenses/new_expense.dart';

class ExpensesApp extends StatefulWidget {
  const ExpensesApp({super.key});

  @override
  State<ExpensesApp> createState() {
    return _ExpensesAppState();
  }
}

class _ExpensesAppState extends State<ExpensesApp> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.00,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense,);
      },
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final index = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: const Text('Expense deleted'),
        action: SnackBarAction(label: 'Undo', onPressed: (){
          setState(() {
            _registeredExpenses.insert(index, expense);
          });
        }),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = Center(child: const Text('No expense found. Start adding some!'));
    if(_registeredExpenses.isNotEmpty) {mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense,);}

    return Scaffold(
      appBar: AppBar(
        title: Text('HQ ExpenseTracker'),
        actions: [IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))],
      ),
      body: 
      width >= 600 ? Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Chart(expenses: _registeredExpenses)),
          Expanded(child: mainContent,),
        ],
      ) :
      Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(child: mainContent,),
        ],
      ),
    );
  }
}
