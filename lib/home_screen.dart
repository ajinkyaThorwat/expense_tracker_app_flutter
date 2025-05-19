import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../widgets/InsightsTab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();
  String selectedDateRange = 'Daily';

  List<ParseObject> expenses = [];
  Map<String, double> expensesByCategory = {};

  final categories = ['Food', 'Travel', 'EMI', 'Shopping'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchExpenses();
  }

  @override
  void dispose() {

    _tabController.dispose();
    super.dispose();
  }

  Map<String, double> calculateCategoryTotals(List<ParseObject> expenses) {
    final Map<String, double> totals = {};

    for (var expense in expenses) {
      final category = expense.get<String>('category') ?? 'Uncategorized';
      final amount = (expense.get<num>('amount') ?? 0).toDouble();
      totals[category] = (totals[category] ?? 0) + amount;
    }

    return totals;
  }

  Future<void> addExpense() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final user = await ParseUser.currentUser();

    if (title.isEmpty || amount <= 0 || user == null) return;

    final expense = ParseObject('Expense')
      ..set('title', title)
      ..set('amount', amount)
      ..set('category', selectedCategory)
      ..set('date', selectedDate)
      ..set('user', user);

    final response = await expense.save();
    if (response.success) {
      _titleController.clear();
      _amountController.clear();
      setState(() {
        selectedCategory = 'Food';
        selectedDate = DateTime.now();
      });
      fetchExpenses();
    } else {
      print('Error saving expense: ${response.error?.message}');
    }
  }

  Future<List<ParseObject>> fetchExpenses() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user == null) return [];

    final query = QueryBuilder<ParseObject>(ParseObject('Expense'))
      ..whereEqualTo('user', user)
      ..orderByDescending('createdAt');

    DateTime endDate = DateTime.now();
    DateTime startDate;

    switch (selectedDateRange) {
      case 'Daily':
        startDate = DateTime(endDate.year, endDate.month, endDate.day);
        break;
      case 'Weekly':
        startDate = endDate.subtract(Duration(days: endDate.weekday - 1));
        break;
      case 'Monthly':
        startDate = DateTime(endDate.year, endDate.month, 1);
        break;
      case 'Quarterly':
        int quarter = ((endDate.month - 1) ~/ 3) + 1;
        int startMonth = (quarter - 1) * 3 + 1;
        startDate = DateTime(endDate.year, startMonth, 1);
        break;
      case 'Yearly':
        startDate = DateTime(endDate.year, 1, 1);
        break;
      default:
        startDate = DateTime(endDate.year, endDate.month, endDate.day);
    }

    query.whereGreaterThanOrEqualsTo('date', startDate);
    query.whereLessThanOrEqualTo('date', endDate);

    final ParseResponse response = await query.query();

    if (response.success && response.results != null) {
      setState(() {
        expenses = response.results!.cast<ParseObject>();
        expensesByCategory = calculateCategoryTotals(expenses);
      });
    } else {
      setState(() {
        expenses = [];
      });
    }

    return expenses;
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text('Expense Tracker'),
            const Spacer(),
            DropdownButton<String>(
              value: selectedDateRange,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedDateRange = value;
                  });
                  fetchExpenses();
                }
              },
              items: ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly']
                  .map((range) => DropdownMenuItem(
                value: range,
                child: Text(range),
              ))
                  .toList(),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Add Expense'),
            Tab(text: 'Insights'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Add Expense Tab with ad banner
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the ad banner if loaded
                        Container(
                          height: 57,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/ad.png',
                            height: 57,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Form for adding expense
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: TextFormField(
                                      controller: _titleController,
                                      decoration: const InputDecoration(
                                        labelText: 'Title',
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'Amount'),
                                  ),
                                  DropdownButton<String>(
                                    value: selectedCategory,
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedCategory = value;
                                        });
                                      }
                                    },
                                    items: categories
                                        .map((cat) => DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat),
                                    ))
                                        .toList(),
                                  ),
                                  TextButton(
                                    onPressed: pickDate,
                                    child: Text(
                                        'Date: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: addExpense,
                                    child: const Text('Add Expense'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Insights Tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InsightsTab(expensesByCategory: expensesByCategory),
                ),
                // History Tab
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final exp = expenses[index];
                      final title = exp.get<String>('title') ?? '';
                      final amount = exp.get<num>('amount') ?? 0;
                      final category = exp.get<String>('category') ?? '';
                      final date = exp.get<DateTime>('date');

                      return ListTile(
                        title: Text('$title - ₹$amount'),
                        subtitle: Text(
                            'Category: $category | Date: ${date?.toLocal().toString().split(' ')[0]}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditDialog(exp),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteExpense(exp),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(ParseObject expense) {
    final editTitleController = TextEditingController(text: expense.get<String>('title'));
    final editAmountController = TextEditingController(text: expense.get<num>('amount')?.toString());
    String editCategory = expense.get<String>('category') ?? 'Food';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Edit Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editTitleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: editAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                  DropdownButton<String>(
                    value: editCategory,
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() {
                          editCategory = value;
                        });
                      }
                    },
                    items: categories.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    )).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    expense
                      ..set('title', editTitleController.text.trim())
                      ..set('amount', double.tryParse(editAmountController.text.trim()) ?? 0.0)
                      ..set('category', editCategory);

                    final response = await expense.save();
                    if (response.success) {
                      Navigator.of(context).pop();
                      fetchExpenses();
                    } else {
                      print('Failed to update: ${response.error?.message}');
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteExpense(ParseObject expense) async {
    final response = await expense.delete();
    if (response.success) {
      fetchExpenses();
    } else {
      print('Error deleting expense: ${response.error?.message}');
    }
  }
}
