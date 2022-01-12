import 'package:flutter/material.dart';

import '../resources/resources.dart';

screenWidth(BuildContext buildContext){
  return MediaQuery.of(buildContext).size.width;
}

screenHeight(BuildContext buildContext){
  return MediaQuery.of(buildContext).size.width;
}

Color themeToColor(theme){
  Color color = blue;
  switch(theme){
    case 'blue' : color = blue; break;
    case 'purple' : color = purple; break;
    case 'pink' : color = pink; break;
    case 'red' : color = red; break;
    case 'orange' : color = orange; break;
    case 'green' : color = green; break;
  }
  return color;
}
