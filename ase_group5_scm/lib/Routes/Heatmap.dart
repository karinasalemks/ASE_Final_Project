@JS()
library heatmap;

import 'package:js/js.dart';

@JS("Heatmap")
class Heatmap {
  external Heatmap();

  external void initMap();

  external void toggleHeatmap();

  external void changeGradient();

  external void changeRadius();

  external void changeOpacity();

  external List getPoints();
}
