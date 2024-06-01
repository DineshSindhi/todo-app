class TodoModel {
  String? userId;
  String? title;
  String? taskDesc;
  String? createdAt;
  String? completedAt;
  String? priority;
  bool? isCompleted;

  TodoModel(
      {required this.title,
      required this.taskDesc,
      required this.createdAt,
       this.userId,
        this.completedAt,
        this.isCompleted=false,
       this.priority='1'
      });

  factory TodoModel.fromDoc(Map<String, dynamic> doc) {
    return TodoModel(
      title: doc['title'],
      taskDesc: doc['taskDesc'],
      createdAt: doc['createdAt'],
      completedAt: doc['completedAt'],
      isCompleted: doc['isCompleted'],
      priority: doc['priority'],
      userId: doc['userId'],
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      'title': title,
      'taskDesc': taskDesc,
      'createdAt': createdAt,
      'completedAt': completedAt,
      'isCompleted': isCompleted,
      'priority': priority,
      'userId': userId,
    };
  }
}
