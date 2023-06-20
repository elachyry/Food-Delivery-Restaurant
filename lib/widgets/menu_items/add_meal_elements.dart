import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/controllers.dart';

class AddMenuElements extends StatefulWidget {
  AddMenuElements({
    super.key,
    required this.elements,
  });

  final Map<String, String> elements;

  final elementsController = TextEditingController();
  final qtyelementsController = TextEditingController();
  final menuItemsController = Get.put(MenuItemsController());

  final RegExp regExp = RegExp(r"^[0-9]+(\.[0-9]+)?$");

  @override
  State<AddMenuElements> createState() => _AddMenuElementsState();
}

class _AddMenuElementsState extends State<AddMenuElements> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    widget.qtyelementsController.text = '1';

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: widget.elementsController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Meal Elements",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Elements field can\'t be empty';
                      }

                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: widget.qtyelementsController,
                    // onChanged: (value) {
                    //   if (widget.qtyelementsController.text.isNotEmpty) {
                    //     widget.menuItemsController.isCleanPrice.value = false;
                    //   } else {
                    //     widget.menuItemsController.isCleanPrice.value = true;
                    //   }
                    // },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Qty",
                    ),
                    validator: (value) {
                      if (!widget.regExp.hasMatch(value as String)) {
                        return 'The entered price must contains only numbers.';
                      }

                      return null;
                    },
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            if (widget.qtyelementsController.text.isEmpty) {
                              widget.qtyelementsController.text = '1';
                            }
                            widget.elements.putIfAbsent(
                                widget.elementsController.text,
                                () => widget.qtyelementsController.text);
                            widget.elementsController.clear();
                            widget.qtyelementsController.text = '1';
                          });
                        }
                      },
                    ))
              ],
            ),
            Container(
                height: widget.elements.isEmpty ? 0 : 100,
                child: ListView.builder(
                  itemCount: widget.elements.keys.length,
                  itemBuilder: (context, index) {
                    final qty = widget.elements.values.elementAt(index);
                    final element = widget.elements.keys.elementAt(index);
                    return ListTile(
                      leading: Text('$qty x'),
                      title: Text(element),
                      trailing: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.elements.removeWhere((key, value) =>
                                key == widget.elements.keys.elementAt(index));
                            print(widget.elements);
                          });
                        },
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
