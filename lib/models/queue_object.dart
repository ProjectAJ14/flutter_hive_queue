import 'package:hive/hive.dart';

part 'queue_object.g.dart';

@HiveType(typeId: 1)
class QueueObject {
  QueueObject() {
    id = '';
    path = '';
    name = '';
    type = '';
    message = '';
    size = 0.0;
    status = 0.0;
    createdAt = DateTime.now();
    data = {};
  }

  @HiveField(0, defaultValue: '')
  late String id;

  @HiveField(1, defaultValue: '')
  late String path; // local path to the file

  @HiveField(2, defaultValue: '')
  late String name; // name of the file

  @HiveField(3, defaultValue: '')
  late String type; // type of the file image/video

  @HiveField(4, defaultValue: '')
  late String message;

  @HiveField(5, defaultValue: 0.0)
  late num size; // size of the file in bytes

  // status of the file 0: not started, 1: in progress, 2: finished, 3: failed
  @HiveField(6, defaultValue: 0.0)
  late num status;

  @HiveField(7)
  late DateTime? createdAt;

  @HiveField(8)
  Map<String, String>? data;

  String get statusText {
    switch (status) {
      case 0:
        return 'Not started';
      case 1:
        return 'In progress';
      case 2:
        return 'Finished';
      case 3:
        return 'Failed';
      default:
        return 'Unknown';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'type': type,
      'message': message,
      'size': size,
      'status': status,
      'createdAt': createdAt,
      'data': data,
    };
  }
}
