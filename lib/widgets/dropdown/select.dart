import 'package:flutter/material.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';

class SelectWidget<T> extends StatefulWidget {
  final List<T> dataset;
  final Function(T value, int index, BuildContext context) onSelectionChanged;
  final dynamic Function(BuildContext context, T value) itemBuilder;
  final int selectedIndex;

  SelectWidget(
      {@required this.dataset, this.onSelectionChanged, this.itemBuilder, this.selectedIndex});

  @override
  _SelectWidgetState createState() => _SelectWidgetState<T>();
}

class _SelectWidgetState<T> extends State<SelectWidget<T>> {
  int selectedCategory = 0;

  DirectSelectItem<T> getDropDownMenuItem(T value) {
    return DirectSelectItem<T>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, T value) => widget.itemBuilder(context, value));
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
            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Container(
              child: Card(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        child: DirectSelectList<T>(
                          onItemSelectedListener: (T value, index, context) =>
                              widget.onSelectionChanged(value, index, context),
                          values: widget.dataset,
                          defaultItemIndex: widget.selectedIndex,
                          itemBuilder: (T value) => getDropDownMenuItem(value),
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
