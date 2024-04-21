import 'package:flutter/material.dart';

import '../constants.dart';

final class HoursPanel extends StatelessWidget {
  final List<int>? enabledTimes;
  final int startTime;
  final int endTime;
  final ValueChanged<int> onTimePressed;
  final bool singleSelection;

  HoursPanel({
    required this.startTime,
    required this.endTime,
    required this.onTimePressed,
    this.enabledTimes,
    super.key,
  }) : singleSelection = false;

  HoursPanel.singleSelection({
    required this.startTime,
    required this.endTime,
    required this.onTimePressed,
    this.enabledTimes,
    super.key,
  }) : singleSelection = true;

  final _lastSelection = ValueNotifier<int?>(null);

  void _onTimePressed(int value, int? lastSelectionValue) {
    onTimePressed(value);
    if (singleSelection) {
      _lastSelection.value = lastSelectionValue == value ? null : value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (var i = startTime; i <= endTime; i++)
              ValueListenableBuilder(
                valueListenable: _lastSelection,
                builder: (_, lastSelectionValue, __) => _TimeButton(
                  label: '${i.toString().padLeft(2, '0')}:00',
                  value: i,
                  onTimePressed: (value) =>
                      _onTimePressed(value, lastSelectionValue),
                  singleSelection: singleSelection,
                  timeSelected: lastSelectionValue,
                  enabledTimes: enabledTimes,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

final class _TimeButton extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onTimePressed;
  final List<int>? enabledTimes;
  final bool singleSelection;
  final int? timeSelected;

  const _TimeButton({
    required this.label,
    required this.value,
    required this.onTimePressed,
    required this.singleSelection,
    required this.timeSelected,
    this.enabledTimes,
  });

  @override
  State<_TimeButton> createState() => _TimeButtonState();
}

final class _TimeButtonState extends State<_TimeButton> {
  var _selected = false;

  @override
  Widget build(BuildContext context) {
    final _TimeButton(
      :value,
      :label,
      :enabledTimes,
      :onTimePressed,
      :singleSelection,
      :timeSelected,
    ) = widget;
    if (singleSelection) {
      if (timeSelected != null) {
        _selected = timeSelected == value;
      }
    }
    final textColor = _selected ? Colors.white : ColorConstants.grey;
    final buttonBorderColor =
        _selected ? ColorConstants.brown : ColorConstants.grey;
    var buttonColor = _selected ? ColorConstants.brown : Colors.white;
    final disabeTime = enabledTimes != null && !enabledTimes.contains(value);

    if (disabeTime) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      onTap: disabeTime ? null : () => _onTimePressed(onTimePressed),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          border: Border.fromBorderSide(BorderSide(color: buttonBorderColor)),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        width: 64,
        height: 36,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _onTimePressed(ValueChanged<int> onTimePressed) {
    onTimePressed(widget.value);
    setState(() => _selected = !_selected);
  }
}
