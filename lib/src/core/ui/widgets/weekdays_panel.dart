import 'package:flutter/material.dart';

import '../constants.dart';

final class WeekdaysPanel extends StatelessWidget {
  final ValueChanged<String> onDayPressed;

  const WeekdaysPanel({required this.onDayPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione os dias da semana',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ButtonDay(label: 'Seg', onDayPressed: onDayPressed),
                _ButtonDay(label: 'Ter', onDayPressed: onDayPressed),
                _ButtonDay(label: 'Qua', onDayPressed: onDayPressed),
                _ButtonDay(label: 'Qui', onDayPressed: onDayPressed),
                _ButtonDay(label: 'Sex', onDayPressed: onDayPressed),
                _ButtonDay(label: 'Sab', onDayPressed: onDayPressed),
                _ButtonDay(label: 'Dom', onDayPressed: onDayPressed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonDay extends StatefulWidget {
  final String label;
  final ValueChanged<String> onDayPressed;

  const _ButtonDay({
    required this.label,
    required this.onDayPressed,
  });

  @override
  State<_ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<_ButtonDay> {
  var _selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = _selected ? Colors.white : ColorConstants.grey;
    final buttonBorderColor =
        _selected ? ColorConstants.brown : ColorConstants.grey;
    final buttonColor = _selected ? ColorConstants.brown : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: _onDayPressed,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            border: Border.fromBorderSide(
              BorderSide(color: buttonBorderColor),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          width: 40,
          height: 56,
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
      ),
    );
  }

  void _onDayPressed() {
    widget.onDayPressed(widget.label);
    setState(() => _selected = !_selected);
  }
}
