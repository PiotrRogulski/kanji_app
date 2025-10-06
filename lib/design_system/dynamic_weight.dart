import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

enum AppDynamicWeight {
  light(300),
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

typedef DynamicWeightData = ({
  AppDynamicWeight weight,
  double fill,
  WidgetStatesController controller,
});

class DynamicWeight extends HookWidget {
  const DynamicWeight({super.key, required this.child});

  final Widget child;

  static DynamicWeightData? maybeOf(BuildContext context) {
    final data = context
        .dependOnInheritedWidgetOfExactType<_DynamicWeightData>();
    if (data == null) {
      return null;
    }
    return (weight: data.weight, fill: data.fill, controller: data.controller);
  }

  static DynamicWeightData of(BuildContext context) {
    final data = maybeOf(context);
    assert(data != null, 'No DynamicWeight found in context');
    return data!;
  }

  @override
  Widget build(BuildContext context) {
    final weight = useState(AppDynamicWeight.light);
    final fill = useState<double>(0);

    final controller = useWidgetStatesController();
    useEffect(() {
      void listener() {
        final (weightValue, fillValue) = _stateMap.entries
            .firstWhere((e) => e.key.isSatisfiedBy(controller.value))
            .value;
        weight.value = weightValue;
        fill.value = fillValue;
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, []);

    return _DynamicWeightData(
      weight: weight.value,
      fill: fill.value,
      controller: controller,
      child: child,
    );
  }
}

class _DynamicWeightData extends InheritedWidget {
  const _DynamicWeightData({
    required this.weight,
    required this.fill,
    required this.controller,
    required super.child,
  });

  final AppDynamicWeight weight;
  final double fill;
  final WidgetStatesController controller;

  @override
  bool updateShouldNotify(_DynamicWeightData old) =>
      weight != old.weight || fill != old.fill || controller != old.controller;
}
