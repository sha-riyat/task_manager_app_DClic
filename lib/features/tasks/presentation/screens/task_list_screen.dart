import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../viewmodels/task_view_model.dart';
import '../widgets/task_card.dart';
import 'edit_task_screen.dart';

/// Main page displaying the list of tasks for the authenticated user. Provides
/// searching, filtering and the ability to add new tasks. If no tasks exist a
/// friendly message is shown instead of an empty list.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final taskVm = context.watch<TaskViewModel>();

    // Ensure the TaskViewModel knows the current user id so it can load data.
    final userId = authVm.user?.id;
    if (userId != null) {
      taskVm.setUserId(userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteFlow'),
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Déconnexion : efface l'utilisateur et revient à l'écran de login
              authVm.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: taskVm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : taskVm.tasks.isEmpty
                    ? const Center(child: Text('Aucune tâche'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: taskVm.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskVm.tasks[index];
                          return Dismissible(
                            key: ValueKey(task.id ?? index),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              taskVm.deleteTask(task);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tâche supprimée')),);
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTaskScreen(task: task),
                                  ),
                                );
                              },
                              child: TaskCard(task: task),
                            ),
                          );
                        },
                      ),
          ),
          // Zone de recherche et actions (ajout et filtre)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: const Border(top: BorderSide(color: Colors.transparent)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.secondary),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              taskVm.setSearchQuery(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Recherche',
                              // Remove all borders from the inner text field so only the outer container has a border
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        if (taskVm.searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              taskVm.setSearchQuery('');
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Bouton d'ajout de tâche
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/new_task');
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Bouton de filtre de statut
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => _StatusFilterSheet(current: taskVm.statusFilter, onSelected: (value) {
                          taskVm.setStatusFilter(value);
                        }),
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
}

/// Bottom sheet allowing the user to select which status to filter tasks by.
class _StatusFilterSheet extends StatelessWidget {
  const _StatusFilterSheet({Key? key, required this.current, required this.onSelected}) : super(key: key);

  final String current;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final statuses = ['Fait', 'En cours', 'A faire', 'Tout'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filtrer par statut', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ...statuses.map((status) {
            final bool selected = current == status;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(status),
              trailing: selected ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                onSelected(status);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}