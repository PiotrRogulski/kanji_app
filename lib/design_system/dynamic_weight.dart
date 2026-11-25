import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

enum AppDynamicWeight(final double value) {
  light(300),
  regular(500),
  bold(900),
}

const _stateMap = {
  WidgetState.pressed: (AppDynamicWeight.bold, 1.0),
  WidgetState.hovered: (AppDynamicWeight.regular, 1.0),
  WidgetState.any: (AppDynamicWeight.light, 0.0),
};

class const DynamicWeightData({
  required final AppDynamicWeight weight,
  required final double fill,
  required final WidgetStatesController controller,
});

class const DynamicWeight({super.key, required final Widget child})
    extends HookWidget {
  static DynamicWeightData? maybeOf(BuildContext context) {
    final data = context
        .dependOnInheritedWidgetOfExactType<_DynamicWeightData>();
    if (data == null) {
      return null;
    }
    return .new(
      weight: data.weight,
      fill: data.fill,
      controller: data.controller,
    );
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

class const _DynamicWeightData({
  required final AppDynamicWeight weight,
  required final double fill,
  required final WidgetStatesController controller,
  required super.child,
}) extends InheritedWidget {
  @override
  bool updateShouldNotify(_DynamicWeightData old) =>
      weight != old.weight || fill != old.fill || controller != old.controller;
}
