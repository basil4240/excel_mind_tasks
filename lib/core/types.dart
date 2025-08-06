import 'package:dartz/dartz.dart' hide Task;

import '../domain/entities/project.dart';
import '../domain/entities/task.dart';
import 'enums/priority.dart';
import 'enums/project_status.dart';
import 'enums/task_status.dart';
import 'errors/failures.dart';

typedef ProjectsResult =
    ({
      Either<Failure, List<Project>> projects,
      Either<Failure, int> totalCount,
      int offset,
      int limit,
    });

typedef CreateProjectData =
    ({
      String name,
      String description,
      String color,
      DateTime startedAt,
      DateTime endedAt,
    });

typedef UpdateProjectData =
    ({
      String? name,
      String? description,
      String? color,
      DateTime? startedAt,
      DateTime? endedAt,
      ProjectStatus? status,
    });

typedef TasksResult =
    ({
      Either<Failure, List<Task>> tasks,
      Either<Failure, int> totalCount,
      int offset,
      int limit,
    });

typedef CreateTaskData =
    ({
      String title,
      String description,
      Priority priority,
      DateTime dueDate,
      int projectId,
    });

typedef UpdateTaskData =
    ({
      String title,
      String description,
      Priority priority,
      TaskStatus status,
      DateTime dueDate,
    });
