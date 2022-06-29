import 'package:hive_flutter/adapters.dart';
import 'package:nike_store/data/product.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = 'favorites';
  final _box = Hive.box<ProductEntity>(_boxName);

  static init() async{
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }

  void add(ProductEntity product){
    _box.put(product.id, product);
  }
  void delete(ProductEntity product){
    _box.delete(product.id);
  }

  List<ProductEntity> get getAll => _box.values.toList();

  bool isFavorite(ProductEntity product){
    return _box.containsKey(product.id);
  }
}