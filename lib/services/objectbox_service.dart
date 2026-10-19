import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/food_entry.dart';
import '../objectbox.g.dart'; // ObjectBox generated code

class ObjectBoxService {
  late final Store store;
  late final Box<FoodEntry> foodBox;

  ObjectBoxService._create(this.store) {
    foodBox = Box<FoodEntry>(store);
  }

  /// 初始化 ObjectBox Store
  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(docsDir.path, "objectbox_food_db");

    final store = await openStore(directory: dbPath);
    return ObjectBoxService._create(store);
  }

  void close() {
    store.close();
  }
}
