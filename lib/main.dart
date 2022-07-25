import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as package_path;
import 'package:path_provider/path_provider.dart';

import 'models/queue_object.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(QueueObjectAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Queue'),
      ),
      body: FutureBuilder<Box<QueueObject>>(
        future: Hive.openBox<QueueObject>('QueueObject'),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ValueListenableBuilder(
              valueListenable: snapshot.data!.listenable(),
              builder: (BuildContext context, box, Widget? child) {
                if (box is Box<QueueObject>) {
                  final List<QueueObject> queue = box.values.toList();

                  return ListView.builder(
                    itemCount: queue.length,
                    itemBuilder: (BuildContext context, int index) {
                      final QueueObject queueObject = queue.elementAt(index);

                      final subtitle = 'Status : ${queueObject.statusText}'
                          '\nMessage : ${queueObject.message}'
                          '\nSize : ${filesize(queueObject.size)}';

                      return ListTile(
                        leading: Image.file(File(queueObject.path)),
                        title: Text(queueObject.name),
                        subtitle: Text(subtitle),
                        onTap: () async {
                          //delete the object
                          await box.deleteAt(index);
                        },
                        onLongPress: () async {
                          //update the object
                          final QueueObject queueObject =
                              queue.elementAt(index);

                          queueObject.status = 2;
                          box.put(queueObject.id, queueObject);
                        },
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();

          final XFile? _file = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 50,
          );
          // Save the image to phone storage.
          if (_file != null) {
            final path = await copyFileToLocal(File(_file.path));
            String basename = package_path.basename(_file.path);

            final box = await Hive.openBox<QueueObject>('QueueObject');
            QueueObject queueObject = QueueObject();
            queueObject.id = '${box.values.length + 1}';
            queueObject.name = basename;
            queueObject.message =
                'This is a message for file ${queueObject.id}';
            queueObject.status = 0;
            queueObject.size = await _file.length();
            queueObject.path = path;
            queueObject.type = 'image';
            box.put(queueObject.id, queueObject);
          }
        },
      ),
    );
  }

  Future<String> copyFileToLocal(File file) async {
    debugPrint('FileService.copyFileToLocal[${file.path}]');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final directory = appDocDir.path;
    final tempFile = File('$directory/${file.path.split('/').last}');
    await tempFile.writeAsBytes(await file.readAsBytes());
    debugPrint('copyFileToLocal.copied[${tempFile.path}]');
    return tempFile.path;
  }
}
