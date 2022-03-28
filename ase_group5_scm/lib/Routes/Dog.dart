@JS()
library dog;
// The above two lines are required
import 'package:js/js.dart';
@JS()
class Dog {
  external Dog(String name, int age);
  external String get name;
  external int get age;
  external void bark();
  external void jump(Function(int height) func);
  external void sleep(Options options);
}
@JS()
@anonymous
class Options {
  external bool get bed;
  external String get hardness;
  external factory Options({bool bed, String hardness});
}