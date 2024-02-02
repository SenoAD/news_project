import 'package:hive/hive.dart';

part 'favourite.g.dart'; // Generated part file

@HiveType(typeId: 0)
class Favourite extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String link;

  Favourite(this.title, this.link);
}