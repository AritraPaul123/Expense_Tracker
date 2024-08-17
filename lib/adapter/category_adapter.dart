import 'package:hive/hive.dart';
import '../constants.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1; // Make sure this is unique across all your adapters

  @override
  Category read(BinaryReader reader) {
    return Category.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer.writeInt(obj.index);
  }
}
