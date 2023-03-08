import 'package:book_n_eat_senior_project/models/menu.dart';
import 'package:flutter/material.dart';

class MenuFormItemWidget extends StatefulWidget {
  MenuFormItemWidget(
      {required Key key,
      required this.menuModel,
      required this.onRemove,
      this.index})
      : super(key: key);

  final index;
  Menu menuModel;
  final Function onRemove;
  final state = _MenuFormItemWidgetState();

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _desController = TextEditingController();
}

class _MenuFormItemWidgetState extends State<MenuFormItemWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contact - ${widget.index}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                //Clear All forms Data
                                widget.menuModel.name = "";
                                widget.menuModel.price = "";
                                widget.menuModel.description = "";
                                widget._nameController.clear();
                                widget._priceController.clear();
                                widget._desController.clear();
                              });
                            },
                            child: Text(
                              "Clear",
                              style: TextStyle(color: Colors.blue),
                            )),
                        TextButton(
                            onPressed: () => widget.onRemove(),
                            child: Text(
                              "Remove",
                              style: TextStyle(color: Colors.blue),
                            )),
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: widget._nameController,
                  // initialValue: widget.menuModel.name,
                  onChanged: (value) => widget.menuModel.name = value,
                  onSaved: (value) => widget.menuModel.name = value!,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Enter Name",
                    labelText: "Name",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget._priceController,
                  onChanged: (value) => widget.menuModel.price = value,
                  onSaved: (value) => widget.menuModel.name = value!,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Enter price",
                    labelText: "price",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget._desController,
                  onChanged: (value) => widget.menuModel.description = value,
                  onSaved: (value) => widget.menuModel.description = value!,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Enter description",
                    labelText: "description",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
