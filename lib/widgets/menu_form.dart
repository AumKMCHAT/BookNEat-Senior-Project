import 'package:book_n_eat_senior_project/models/menu.dart';
import 'package:book_n_eat_senior_project/utils/colors.dart';
import 'package:flutter/material.dart';

typedef OnDelete = Function();

class MenuForm extends StatefulWidget {
  final Menu menu;
  final OnDelete onDelete;
  final state = _MenuFormState();

  MenuForm({required Key key, required this.menu, required this.onDelete});

  @override
  State<MenuForm> createState() => _MenuFormState();

  bool isValid() => state.validate();
}

class _MenuFormState extends State<MenuForm> {
  final form = GlobalKey<FormState>();
  bool validate() {
    var valid = form.currentState!.validate();
    if (valid) form.currentState!.save();
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                leading: const Icon(Icons.verified_user),
                elevation: 0,
                title: const Text('Menu Details'),
                backgroundColor: secondaryColor,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: TextFormField(
                  initialValue: widget.menu.name,
                  onSaved: (val) => widget.menu.name = val!,
                  validator: (val) => val != null ? null : "invalid",
                  decoration: const InputDecoration(
                    labelText: 'Menu Name',
                    hintText: 'Menu Name',
                    icon: Icon(Icons.info_outline_rounded),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
                child: TextFormField(
                  initialValue: widget.menu.price,
                  onSaved: (val) => widget.menu.price = val!,
                  validator: (val) => val != null ? null : "invalid",
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Price',
                    icon: Icon(Icons.attach_money_rounded),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 5, bottom: 10),
                child: TextFormField(
                  initialValue: widget.menu.description,
                  onSaved: (val) => widget.menu.description = val!,
                  validator: (val) => val != null ? null : "invalid",
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Description',
                    icon: Icon(Icons.chat_outlined),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
