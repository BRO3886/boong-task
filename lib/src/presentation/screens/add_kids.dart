import 'package:boong_task/src/helpers/add_data.dart';
import 'package:flutter/material.dart';

class AddChildren extends StatefulWidget {
  final int number;

  const AddChildren({Key key, @required this.number}) : super(key: key);
  @override
  _AddChildrenState createState() => _AddChildrenState();
}

class _AddChildrenState extends State<AddChildren> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> ageControllers = [];

  List<TextFormField> nameFields = [];

  List<TextFormField> ageFields = [];

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    for (int i = 0; i < widget.number; i++) {
      TextEditingController controller = new TextEditingController();
      nameControllers.add(controller);
      nameFields.add(TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Child ${i + 1}'s name",
        ),
        validator: (val) {
          if (val.isEmpty) {
            return "This field is required";
          }
          if (val.contains(",")) {
            return "Commas not allowed";
          }
        },
      ));
      TextEditingController anotherController = new TextEditingController();
      ageControllers.add(anotherController);
      ageFields.add(TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Child ${i + 1}'s age",
        ),
        controller: anotherController,
        validator: (val) {
          if (val.isEmpty) {
            return "This field is required";
          }
          if (val.contains(",")) {
            return "Commas not allowed";
          }
        },
      ));
    }
    super.initState();
  }

  List<Widget> buildChildren() {
    final list = <Widget>[];
    for (int i = 0; i < widget.number; i++) {
      list.add(ageFields[i]);
      list.add(SizedBox(
        height: 16,
      ));
      list.add(nameFields[i]);
      list.add(SizedBox(
        height: 16,
      ));
    }
    return list;
  }

  String createChildStrings() {
    String names = "";
    String ages = "";
    for (int i = 0; i < widget.number; i++) {
      names += "${nameControllers[i].text}\t";
      ages += "${ageControllers[i].text}\t";
    }
    names.replaceFirst("\t", "", names.length);
    ages.replaceFirst("\t", "", ages.length);

    print(names);
    print(ages);

    return "$names,$ages";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Children'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ...buildChildren(),
                SizedBox(
                  height: 32,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  child: RaisedButton(
                    onPressed: () {
                      if (!_formkey.currentState.validate()) {
                        return;
                      }
                      print("all good");
                      Navigator.pop<String>(context, createChildStrings());
                    },
                    textColor: Colors.white,
                    child: Text('SUBMIT'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
