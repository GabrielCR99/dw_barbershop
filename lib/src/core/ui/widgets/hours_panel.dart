import 'package:flutter/material.dart';

import '../constants.dart';

final class HoursPanel extends StatelessWidget {
  final int startTime;
  final int endTime;
  final ValueChanged<int> onTimePressed;

  const HoursPanel({
    required this.startTime,
    required this.endTime,
    required this.onTimePressed,
    super.key,
  });

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
              _TimeButton(
                label: '${i.toString().padLeft(2, '0')}:00',
                value: i,
                onTimePressed: onTimePressed,
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

  const _TimeButton({
    required this.label,
    required this.value,
    required this.onTimePressed,
  });

  @override
  State<_TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<_TimeButton> {
  var _selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = _selected ? Colors.white : ColorConstants.grey;
    final buttonBorderColor =
        _selected ? ColorConstants.brown : ColorConstants.grey;
    final buttonColor = _selected ? ColorConstants.brown : Colors.white;

    return InkWell(
      onTap: _onTimePressed,
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
            widget.label,
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

  void _onTimePressed() {
    widget.onTimePressed(widget.value);
    setState(() => _selected = !_selected);
  }
}
