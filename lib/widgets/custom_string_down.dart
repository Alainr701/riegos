import 'package:flutter/material.dart';

class StringDropdown extends StatefulWidget {
  const StringDropdown(
      {Key? key,
      required this.values,
      this.onChanged,
      required this.initialValue,
      required this.selectedColor,
      this.withBorder = true,
      this.title,
      this.textFieldFormat = true})
      : super(key: key);
  final List<String> values;
  final ValueChanged<String?>? onChanged;
  final String initialValue;
  final bool textFieldFormat;
  final Color selectedColor;
  final bool withBorder;
  final String? title;

  @override
  State<StringDropdown> createState() => _StringDropdownState();
}

class _StringDropdownState extends State<StringDropdown> {
  String dropdownvalue = "";
  @override
  void initState() {
    super.initState();
    dropdownvalue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final dropdown = SizedBox(
        height: 40,
        child: DropdownButtonFormField<String>(
          borderRadius: BorderRadius.circular(10.0),
          isExpanded: true,
          style: const TextStyle(fontSize: 15),
          // underline: const SizedBox(),
          decoration: widget.withBorder
              ? InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 5 * 2.5, vertical: 5),
                  border: OutlineInputBorder(
                      gapPadding: 5, borderRadius: BorderRadius.circular(10.0)),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 5,
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: widget.selectedColor),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  fillColor: Colors.white70,
                )
              : const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 5 * 2.5, vertical: 5),
                ),
          isDense: true,
          value: dropdownvalue,
          icon: Icon(Icons.arrow_drop_down_outlined,
              color: widget.selectedColor, size: 15),
          items: widget.values.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items.toString(),
                  style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            widget.onChanged?.call(newValue);
            setState(() {
              dropdownvalue = newValue!;
            });
          },
        ));
    if (widget.title == null) {
      return dropdown;
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title!, style: const TextStyle(color: Color(0xFF000000))),
          dropdown
        ],
      );
    }
  }
}
