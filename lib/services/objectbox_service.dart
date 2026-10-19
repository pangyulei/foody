import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/custom_food.dart';
import '../models/diet_log.dart';
import '../models/premade_food.dart';
import '../objectbox.g.dart'; // ObjectBox generated code

class ObjectBoxService {
  late final Store store;
  late final Box<PremadeFood> premadeFoodBox;
  late final Box<CustomFood> customFoodBox;
  late final Box<DietLog> dietLogBox;

  ObjectBoxService._create(this.store) {
    premadeFoodBox = Box<PremadeFood>(store);
    customFoodBox = Box<CustomFood>(store);
    dietLogBox = Box<DietLog>(store);
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
