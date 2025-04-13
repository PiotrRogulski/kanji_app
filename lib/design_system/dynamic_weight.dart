import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

enum AppDynamicWeight {
  light(200),
  regular(500),
  bold(900);

  const AppDynamicWeight(this.value);

  final double value;
}

const _stateMap = {
  WidgetState.pressed: (AppDynamicWeight.bold, 1.0),
  WidgetState.hovered: (AppDynamicWeight.regular, 1.0),
  WidgetState.any: (AppDynamicWeight.light, 0.0),
};

({AppDynamicWeight weight, double fill, WidgetStatesController controller})
useDynamicWeight() {
  final iconWeight = useState(AppDynamicWeight.light);
  final fill = useState<double>(0);

  final controller = useMaterialStatesController();
  useEffect(() {
    void listener() {
      final (weightValue, fillValue) =
          _stateMap.entries
              .firstWhere((e) => e.key.isSatisfiedBy(controller.value))
              .value;
      iconWeight.value = weightValue;
      fill.value = fillValue;
    }

    controller.addListener(listener);
    return () => controller.removeListener(listener);
  }, []);

  return (weight: iconWeight.value, fill: fill.value, controller: controller);
}
