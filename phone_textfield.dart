import 'package:flutter/material.dart';
import './call_log.dart';

class PhoneTextField extends StatefulWidget {
  final Function(String)? update;

  const PhoneTextField({Key? key, this.update}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PhoneTextFieldState createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  TextEditingController t1 = TextEditingController();
  CallLogs cl = CallLogs();

  @override
  void initState() {
    super.initState();
    t1.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: TextField(
        controller: t1,
        decoration: InputDecoration(
          labelText: "Phone number",
          contentPadding: const EdgeInsets.all(10),
          suffixIcon: t1.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    if (widget.update != null) {
                      widget.update!(t1.text);
                    }
                    cl.call(t1.text);
                  },
                )
              : null,
        ),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          if (widget.update != null) {
            widget.update!(t1.text);
          }
          cl.call(t1.text);
        },
      ),
    );
  }
}