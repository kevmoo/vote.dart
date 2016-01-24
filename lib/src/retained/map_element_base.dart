import 'package:bot/bot.dart' hide ReadOnlyCollection;

abstract class MapElementBase {
  void setTransform(AffineTransform value);
  void set radius(num value);
}
