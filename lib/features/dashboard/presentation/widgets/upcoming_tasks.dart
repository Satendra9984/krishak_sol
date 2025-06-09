import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:bhoomi_sakti/app/config/theme/app_colors.dart';

class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final String status;
  final Color statusColor;

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.status,
    required this.statusColor,
  });
}

class UpcomingTasks extends StatelessWidget {
  UpcomingTasks({super.key});

  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Soil Sample Collection',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      status: 'Pending',
      statusColor: Colors.orange,
    ),
    Task(
      id: '2',
      title: 'Fertilizer Application',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      status: 'Scheduled',
      statusColor: Colors.blue,
    ),
    Task(
      id: '3',
      title: 'Irrigation',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      status: 'Due Soon',
      statusColor: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(task);
      },
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: task.statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${DateFormat('MMM dd, yyyy').format(task.dueDate)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: task.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              task.status,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: task.statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.grey[400], size: 48),
          const SizedBox(height: 8),
          Text(
            'No upcoming tasks',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You\'re all caught up!',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
