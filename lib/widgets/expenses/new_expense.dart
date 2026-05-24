import 'package:flutter/material.dart';
import 'package:hqexpensetracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category? _seletedCategory;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final isAmountInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        isAmountInvalid ||
        _selectedDate == null ||
        _seletedCategory == null) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            spacing: 12,
            children: [
              const Icon(Icons.error, color: Colors.red),
              const Text('Invalid Input!', style: TextStyle(
                color: Colors.red,
              ),),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Text(
                  'Please make sure you entered all the required data',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 189, 38, 31),
                    fontWeight: FontWeight.bold,

                  ),
                  
                ),    
              SizedBox(height: 16),
              if (_titleController.text.trim().isEmpty)
                RichText(
                  text: TextSpan(
                  style: TextStyle(color: Colors.red),
                  children: <TextSpan>[
                    TextSpan(text:'Title', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                    TextSpan(text:' can\'t be empty')
                  ]

                  ),
                ),
              if (isAmountInvalid)
                RichText(
                  text: TextSpan(
                  style: TextStyle(color: Colors.red),
                  children: <TextSpan>[
                    TextSpan(text:'Invalid '),
                    TextSpan(text:'amount', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ]
                  ),  
                ),            
              if (_selectedDate == null)
                RichText(
                  text: TextSpan(
                  style: TextStyle(color: Colors.red),
                  children: <TextSpan>[
                    TextSpan(text:'Please pick '),
                    TextSpan(text:'date', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ]
                  ),  
                ),                          
              if (_seletedCategory == null)
                RichText(
                  text: TextSpan(
                  style: TextStyle(color: Colors.red),
                  children: <TextSpan>[
                    TextSpan(text:'Select '),
                    TextSpan(text:'category', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ]
                  ),  
                ),                                        
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(Expense(title: _titleController.text.trim(), amount: enteredAmount, date: _selectedDate!, category: _seletedCategory!));
    Navigator.pop(context);
  }

  @override
  dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,50,16,16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(label: const Text('Title')),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: const Text('Amount'),
                    prefixText: '৳ ',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date seleted'
                          : dateFormatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              DropdownButton(
                value: _seletedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _seletedCategory = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cencle'),
              ),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
