import 'dart:math';
import 'package:sqflite/sqflite.dart';

class DatabaseSeeder {
  static final Random _random = Random();

  static final List<String> _projectNames = [
    'Mobile App Development',
    'Website Redesign',
    'Marketing Campaign',
    'Database Migration',
    'API Integration',
    'User Research',
    'Product Launch',
    'Security Audit',
    'Performance Optimization',
    'Content Management',
    'E-commerce Platform',
    'Social Media Strategy',
    'Customer Onboarding',
    'Analytics Dashboard',
    'Payment Gateway',
    'Inventory Management',
    'HR Management System',
    'Document Management',
    'Quality Assurance',
    'DevOps Pipeline',
    'Cloud Migration',
    'Machine Learning Model',
    'Blockchain Integration',
    'IoT Development',
    'Game Development'
  ];

  static final List<String> _projectDescriptions = [
    'A comprehensive project to improve user experience',
    'Strategic initiative to enhance business operations',
    'Critical system upgrade for better performance',
    'Innovation project to drive growth',
    'Essential maintenance and optimization work',
    'Research and development initiative',
    'Customer-focused improvement project',
    'Technology modernization effort',
    'Process automation and efficiency project',
    'Data-driven decision making platform'
  ];

  static final List<String> _colors = [
    '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
    '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9',
    '#F8C471', '#82E0AA', '#F1948A', '#85C1E9', '#D7BDE2',
    '#A3E4D7', '#F9E79F', '#D5A6BD', '#AED6F1', '#A9DFBF',
    '#FAD7A0', '#D2B4DE', '#AED6F1', '#A9CCE3', '#F7DC6F'
  ];

  static final List<String> _taskTitles = [
    'Setup development environment',
    'Create wireframes and mockups',
    'Implement authentication system',
    'Design database schema',
    'Write unit tests',
    'Perform code review',
    'Update documentation',
    'Fix critical bugs',
    'Optimize performance',
    'Deploy to staging',
    'User acceptance testing',
    'Security vulnerability scan',
    'Backup and recovery setup',
    'Monitor system metrics',
    'Implement feature flags',
    'Setup CI/CD pipeline',
    'Configure load balancer',
    'Update dependencies',
    'Refactor legacy code',
    'Setup monitoring alerts',
    'Create API documentation',
    'Implement caching layer',
    'Setup error tracking',
    'Performance benchmarking',
    'Code quality analysis',
    'Data migration script',
    'Setup logging system',
    'Implement search functionality',
    'Create admin dashboard',
    'Setup notification system',
    'Implement file upload',
    'Create user roles',
    'Setup payment processing',
    'Implement email templates',
    'Create reporting system',
    'Setup backup automation',
    'Implement data validation',
    'Create mobile responsive design',
    'Setup SSL certificates',
    'Implement rate limiting',
    'Create integration tests',
    'Setup database indexing',
    'Implement audit logging',
    'Create help documentation',
    'Setup health checks'
  ];

  static final List<String> _taskDescriptions = [
    'Configure necessary tools and dependencies',
    'Create detailed visual representations of the interface',
    'Develop secure user login and registration',
    'Design efficient data storage structure',
    'Write comprehensive test coverage',
    'Ensure code quality and best practices',
    'Keep project documentation current',
    'Resolve high-priority system issues',
    'Improve application speed and efficiency',
    'Release to testing environment',
    'Validate functionality with end users',
    'Identify and fix security weaknesses',
    'Implement data protection measures',
    'Track system health and performance',
    'Enable controlled feature rollouts',
    'Automate testing and deployment',
    'Distribute traffic across servers',
    'Keep third-party libraries current',
    'Improve code maintainability',
    'Set up automated system alerts',
    'Document API endpoints and usage',
    'Implement data caching strategy',
    'Track and log application errors',
    'Measure system performance metrics',
    'Analyze code quality metrics',
    'Transfer data between systems',
    'Implement comprehensive logging',
    'Add search capabilities to application',
    'Create administrative interface',
    'Setup user notification system'
  ];

  static final List<String> _priorities = ['low', 'medium', 'high'];
  static final List<String> _statuses = ['incomplete', 'complete'];

  static Future<void> seedDatabase(Database db) async {
    final now = DateTime.now();
    final projectsData = <Map<String, dynamic>>[];
    final tasksData = <Map<String, dynamic>>[];

    // Generate 25 projects
    for (int i = 0; i < 25; i++) {
      final projectStartDate = now.subtract(Duration(days: _random.nextInt(180)));
      final projectEndDate = _random.nextBool()
          ? projectStartDate.add(Duration(days: 30 + _random.nextInt(120)))
          : null;

      final project = {
        'name': _projectNames[i],
        'description': _projectDescriptions[_random.nextInt(_projectDescriptions.length)],
        'color': _colors[_random.nextInt(_colors.length)],
        'startedAt': projectStartDate.millisecondsSinceEpoch,
        'endedAt': projectEndDate?.millisecondsSinceEpoch,
        'tasksCount': 0, // Will be updated after tasks are created
        'completedTasks': 0,
        'progress': 0.0,
        'createdAt': projectStartDate.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      };

      projectsData.add(project);
    }

    // Insert projects and get their IDs
    final projectIds = <int>[];
    for (final project in projectsData) {
      final id = await db.insert('projects', project);
      projectIds.add(id);
    }

    // Generate tasks for each project (12-17 tasks per project)
    for (int projectIndex = 0; projectIndex < projectIds.length; projectIndex++) {
      final projectId = projectIds[projectIndex];
      final numTasks = 12 + _random.nextInt(6); // 12-17 tasks
      final usedTitles = <String>{};

      for (int taskIndex = 0; taskIndex < numTasks; taskIndex++) {
        // Ensure unique task titles within a project
        String taskTitle;
        do {
          taskTitle = _taskTitles[_random.nextInt(_taskTitles.length)];
        } while (usedTitles.contains(taskTitle));
        usedTitles.add(taskTitle);

        final taskCreatedDate = now.subtract(Duration(days: _random.nextInt(90)));
        final hasDueDate = _random.nextBool();
        final dueDate = hasDueDate
            ? taskCreatedDate.add(Duration(days: 1 + _random.nextInt(60)))
            : null;

        // Higher chance of incomplete tasks (70% incomplete, 30% complete)
        final status = _random.nextDouble() < 0.7 ? 'incomplete' : 'complete';

        // Priority distribution: 50% low, 30% medium, 20% high
        String priority;
        final priorityRandom = _random.nextDouble();
        if (priorityRandom < 0.5) {
          priority = 'low';
        } else if (priorityRandom < 0.8) {
          priority = 'medium';
        } else {
          priority = 'high';
        }

        final task = {
          'title': taskTitle,
          'description': _taskDescriptions[_random.nextInt(_taskDescriptions.length)],
          'status': status,
          'priority': priority,
          'dueDate': dueDate?.millisecondsSinceEpoch,
          'projectId': projectId,
          'createdAt': taskCreatedDate.millisecondsSinceEpoch,
          'updatedAt': taskCreatedDate.add(Duration(hours: _random.nextInt(24))).millisecondsSinceEpoch,
        };

        tasksData.add(task);
      }
    }

    // Batch insert tasks for better performance
    final batch = db.batch();
    for (final task in tasksData) {
      batch.insert('tasks', task);
    }
    await batch.commit(noResult: true);

    for (int i = 0; i < projectIds.length; i++) {
      final projectId = projectIds[i];
      final projectTasks = tasksData.where((task) => task['projectId'] == projectId).toList();
      final completedCount = projectTasks.where((task) => task['status'] == 'complete').length;
      final progress = projectTasks.isNotEmpty ? completedCount / projectTasks.length : 0.0;

      await db.update('projects', {
        'tasksCount': projectTasks.length,
        'completedTasks': completedCount,
        'progress': progress,
      }, where: 'id = ?', whereArgs: [projectId]);
    }

    print('Database seeded successfully!');
    print('Created ${projectsData.length} projects and ${tasksData.length} tasks');
  }
}