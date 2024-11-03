import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/utils/helper.dart';
import 'package:todo_app/features/home/bloc/bloc/todo_bloc.dart';
import 'package:todo_app/features/home/todo_detail/bloc/bloc/todo_detail_bloc.dart';

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({super.key, required this.id, required this.user});
  static const routeName = '/todo-detail';
  final String id;
  final User user;

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? selectedDueDate;

  @override
  void initState() {
    super.initState();
    // Load todo details
    context.read<TodoDetailBloc>().add(TodoDetailLoad(widget.id, widget.user));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize controllers after the state loads
    final state = context.watch<TodoDetailBloc>().state;
    if (state is TodoDetailLoaded) {
      titleController = TextEditingController(text: state.todo.title);
      descriptionController =
          TextEditingController(text: state.todo.description);
      selectedDueDate = state.todo.dueDate;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Detail'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context
                  .read<TodoDetailBloc>()
                  .add(TodoDetailDelete(widget.id, widget.user));
            },
          ),
        ],
      ),
      body: BlocConsumer<TodoDetailBloc, TodoDetailState>(
        listener: (context, state) {
          if (state is TodoDetailDeleted) {
            context.read<TodoBloc>().add(TodoLoad(widget.user));
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Todo deleted successfully')),
            );
          } else if (state is TodoDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is TodoDetailUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Todo updated successfully')),
            );
          }
        },
        builder: (context, state) {
          if (state is TodoDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoDetailLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                          'Due Date: ${selectedDueDate != null ? formatDate(selectedDueDate!) : 'None'}'),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDueDate(context),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      final updatedTodo = state.todo.copyWith(
                        title: titleController.text,
                        description: descriptionController.text,
                        dueDate: selectedDueDate,
                      );
                      context.read<TodoDetailBloc>().add(
                            TodoDetailUpdate(updatedTodo, widget.user),
                          );
                      context.pop();
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Error loading todo details'));
          }
        },
      ),
    );
  }
}
