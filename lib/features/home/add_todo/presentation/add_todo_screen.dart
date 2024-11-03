import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/data/models/remote/todo.dart';
import 'package:todo_app/features/home/add_todo/bloc/bloc/add_todo_bloc.dart';
import 'package:todo_app/features/home/bloc/bloc/todo_bloc.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key, required this.user});
  final User user;
  static const routeName = '/add-todo';

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? dueDate;

  // Function to show a date picker and set the due date
  Future<void> _pickDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selectedDate != null) {
      setState(() {
        dueDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo"),
        leading: IconButton(
            onPressed: () => context.pop(), icon: Icon(Icons.arrow_back)),
      ),
      body: BlocConsumer<AddTodoBloc, AddTodoState>(
        listener: (context, state) {
          if (state is AddTodoSuccess) {
            Navigator.of(context).pop();
            context.read<TodoBloc>().add(TodoLoad(widget.user));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      dueDate == null
                          ? 'No due date selected'
                          : 'Due Date: ${dueDate!.toLocal().toString().split(' ')[0]}',
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _pickDueDate(context),
                      iconSize: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final todo = Todo(
                      id: '',
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: dueDate,
                      isCompleted: false,
                      createdAt: DateTime.now(),
                    );
                    context
                        .read<AddTodoBloc>()
                        .add(AddTodoAdd(todo, widget.user));
                  },
                  child: const Text("Add Todo"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
