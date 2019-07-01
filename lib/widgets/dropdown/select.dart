import 'package:flutter/material.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';

class SelectWidget extends StatefulWidget {
  final List<String> dataset;

  SelectWidget({@required this.dataset});

  @override
  _SelectWidgetState createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  int selectedCategory = 0;

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

  _selectionDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  Icon _dropdownIcon() {
    return Icon(
      Icons.unfold_more,
      color: Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0,),
            child: Container(
              child: Card(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        child: DirectSelectList<String>(
                          values: widget.dataset,
                          defaultItemIndex: 0,
                          itemBuilder: (String value) =>
                              getDropDownMenuItem(value),
                          focusedItemDecoration: _selectionDecoration(),
                        ),
                        padding: EdgeInsets.only(left: 12),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: _dropdownIcon(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
