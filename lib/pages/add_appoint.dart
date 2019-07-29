import 'dart:async';

import 'package:appoint/actions/add_appoint_action.dart';
import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/utils/calendar.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/view_models/add_appoint_vm.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/pages/select_period.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/settings_vm.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/icon_circle_gradient.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/pages/select_company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddAppoint extends StatefulWidget {
  final Appoint appoint;
  final bool isEditing;

  AddAppoint({Key key, this.isEditing = false, this.appoint}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddAppointState();
  }
}

class AddAppointState extends State<AddAppoint>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _appointFormKey = GlobalKey<FormState>();

  String _title;
  Company _company;
  Period _period;
  String _description;

  bool get isEditing => widget.isEditing;

  bool hideKeyboardEnabled = true;

  @override
  void initState() {
    if (isEditing) {
      _company = widget.appoint.company;
      _title = widget.appoint.title;
      _period = widget.appoint.period;
      _description = widget.appoint.description;

      _titleController.text = _title;
    }

    _titleController.addListener(onTitleChange);
    _descriptionController.addListener(onDescriptionChange);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _titleFocus = FocusNode();

  void scrollInProgress() {
    hideKeyboardEnabled = false;
  }

  void scrollDone() {
    hideKeyboardEnabled = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }

  void onTitleChange() {
    setState(() {
      _title = _titleController.text;
    });
  }

  void onDescriptionChange() {
    setState(() {
      _description = _descriptionController.text;
    });
  }

  bool _isValid() {
    return _title != null &&
        _title.isNotEmpty &&
        _company != null &&
        _period != null;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        if (isEditing) {}
      },
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: buildNavBar(vm),
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: NotificationListener(
              onNotification: (t) {
                if (t is UserScrollNotification) {
                  if (hideKeyboardEnabled) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                }
              },
              child: CupertinoScrollbar(
                child: Form(
                  key: _appointFormKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      _firstCard(),
                      /*SizedBox(
                        height: 20,
                      ),*/
                      //_secondCard(),
                      SizedBox(
                        height: 20,
                      ),
                      _thirdCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNavBar(_ViewModel vm) {
    return NavBar(
      isEditing ? "Bearbeiten" : "Neuer Termin",
      height: 57,
      leadingWidget: IconButton(
        icon: Icon(Icons.close),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          vm.cancelEditOrAdd();
          Navigator.pop(context);
        },
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(
          isEditing ? "Speichern" : "Erstellen",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isValid() ? Color(0xff09c199) : null),
        ),
        onPressed: _isValid()
            ? () {
                vm.saveAppoint(Appoint(
                  id: isEditing ? widget.appoint.id : null,
                  title: _title,
                  company: _company,
                  period: _period,
                  description: _description,
                ));

                if (vm.settingsViewModel
                            .settings[kSettingsCalendarIntegration] ==
                        true &&
                    vm.settingsViewModel.settings[kSettingsSaveToCalendar] ==
                        true) {
                  Calendar()
                      .createNativeCalendarEvent(
                          vm.settingsViewModel.settings[kSettingsCalendarId],
                          _period.start,
                          _title,
                          _period.duration,
                          _description,
                          _company)
                      .then((res) {
                    if (res) {
                      //TODO: show indicator that an event was created inside calendar
                      /* showCupertinoDialog(
                        context: context,
                        builder: (context) => prefix0.Dialog(
                          title: "Termin erstellt",
                          information:
                              "Termin wurde in den Kalender übertragen",
                          informationTextSize: 24,
                        ),
                      ); 
                      Future.delayed(Duration(milliseconds: 200), () {
                        //first: pop dialog, then pop add_appoint page
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }); */
                    }
                  });
                }
                Navigator.pop(context);
              }
            : null,
      ),
    );
  }

  Widget _firstCard() {
    final Function companyTap = () => showCupertinoModalPopup(
          context: context,
          builder: (context) => SelectCompany(),
        ).then((selectedCompany) {
          if (selectedCompany != null) {
            setState(() {
              _company = selectedCompany;
              _period = null;
            });
          }
        });

    return EnsureVisibleWhenFocused(
      scrollDone: () => scrollDone,
      scrollInProgress: () => scrollInProgress,
      focusNode: _titleFocus,
      child: Card(
        elevation: 2,
        child: Column(
          children: <Widget>[
            _buildTitleTextField(companyTap),
            _buildDivider(),
            _company == null
                ? _buildSelectCompanyButton(companyTap)
                : _buildCompanyTile(companyTap),
            _buildDivider(),
            _period == null ? _buildSelectPeriodButton() : _buildPeriodTile(),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildPeriodTile() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _selectPeriodPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              Align(
                child: Text(
                  Parse.dateWithWeekday.format(_period.start),
                  style: TextStyle(fontSize: 17),
                ),
                alignment: Alignment.centerLeft,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    IconCircleGradient.periodIndicator(
                        _period.duration.inMinutes / 60),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${Parse.hoursWithMinutes.format(_period.start)} - ${Parse.hoursWithMinutes.format(_period.getPeriodEnd())}",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildSelectPeriodButton() {
    return Container(
      height: 50,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Zeitraum auswählen..."),
            Icon(
              CupertinoIcons.getIconData(0xf3d0),
              color: Colors.grey[350],
            ),
          ],
        ),
        onPressed: _company == null ? null : _selectPeriodPressed,
      ),
    );
  }

  Container _buildCompanyTile(Function companyTap) {
    return Container(
      color: isEditing ? Colors.grey[350] : null,
      child: CompanyTile(
        isStatic: true,
        company: _company,
        onTap: isEditing ? null : companyTap,
      ),
    );
  }

  Container _buildSelectCompanyButton(Function companyTap) {
    return Container(
      height: 50,
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Unternehmen auswählen..."),
            Icon(
              CupertinoIcons.getIconData(0xf3d0),
              color: Colors.black,
            ),
          ],
        ),
        onPressed: companyTap,
      ),
    );
  }

  Row _buildTitleTextField(Function companyTap) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 50,
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Align(
              child: TextFormField(
                controller: _titleController,
                autofocus: isEditing ? false : true,
                style: TextStyle(color: Colors.black),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _titleFocus.unfocus();
                  companyTap();
                },
                decoration: InputDecoration(
                    hintText: "Titel",
                    suffixIcon: _titleController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              CupertinoIcons.clear_circled_solid,
                              size: 16,
                              color: Colors.grey[350],
                            ),
                            onPressed: () => _titleController.text = "",
                          )
                        : null,
                    border: InputBorder.none),
              ),
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }

  Container _buildDivider() {
    return Container(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Divider(
        height: 1,
      ),
    );
  }

  Widget _thirdCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: EnsureVisibleWhenFocused(
            scrollDone: () => scrollDone,
            scrollInProgress: () => scrollInProgress,
            focusNode: _descriptionFocus,
            child: TextFormField(
              focusNode: _descriptionFocus,
              controller: _descriptionController,
              minLines: 6,
              maxLines: 6,
              maxLength: 256,
              decoration: InputDecoration(
                  hintText: "Information zum Termin:",
                  suffixIcon: _descriptionController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            CupertinoIcons.clear_circled_solid,
                            size: 16,
                            color: Colors.grey[350],
                          ),
                          onPressed: () => _descriptionController.text = "",
                        )
                      : null,
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }

  void _selectPeriodPressed() => showCupertinoModalPopup(
        context: context,
        builder: (context) => SelectPeriod(
          companyId: _company.id,
        ),
      ).then(
        (selectedPeriod) {
          if (selectedPeriod != null) {
            setState(() {
              _period = selectedPeriod;
            });
          }
        },
      );
}

class _ViewModel {
  final AddAppointViewModel addAppointViewModel;
  final Function(Appoint appoint) saveAppoint;
  final Function cancelEditOrAdd;
  final SettingsViewModel settingsViewModel;

  _ViewModel(
      {@required this.addAppointViewModel,
      this.saveAppoint,
      this.cancelEditOrAdd,
      this.settingsViewModel});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      addAppointViewModel: store.state.addAppointViewModel,
      saveAppoint: (Appoint appoint) =>
          store.dispatch(AddAppointmentAction(appoint)),
      cancelEditOrAdd: () => store.dispatch(CancelEditOrAddAppointAction()),
      settingsViewModel: store.state.settingsViewModel,
    );
  }
}

class EnsureVisibleWhenFocused extends StatefulWidget {
  const EnsureVisibleWhenFocused({
    Key key,
    @required this.child,
    @required this.focusNode,
    this.curve: Curves.ease,
    this.scrollDone,
    this.scrollInProgress,
    this.duration: const Duration(milliseconds: 100),
  }) : super(key: key);

  /// The node we will monitor to determine if the child is focused
  final FocusNode focusNode;

  /// The child widget that we are wrapping
  final Widget child;

  /// The curve we will use to scroll ourselves into view.
  ///
  /// Defaults to Curves.ease.
  final Curve curve;

  /// The duration we will use to scroll ourselves into view
  ///
  /// Defaults to 100 milliseconds.
  final Duration duration;

  final Function scrollInProgress;
  final Function scrollDone;

  @override
  _EnsureVisibleWhenFocusedState createState() =>
      new _EnsureVisibleWhenFocusedState();
}

class _EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.focusNode.removeListener(_ensureVisible);
    super.dispose();
  }

  ///
  /// This routine is invoked when the window metrics have changed.
  /// This happens when the keyboard is open or dismissed, among others.
  /// It is the opportunity to check if the field has the focus
  /// and to ensure it is fully visible in the viewport when
  /// the keyboard is displayed
  ///
  @override
  void didChangeMetrics() {
    if (widget.focusNode.hasFocus) {
      _ensureVisible();
    }
  }

  ///
  /// This routine waits for the keyboard to come into view.
  /// In order to prevent some issues if the Widget is dismissed in the
  /// middle of the loop, we need to check the "mounted" property
  ///
  /// This method was suggested by Peter Yuen (see discussion).
  ///
  Future<Null> _keyboardToggled() async {
    if (mounted) {
      EdgeInsets edgeInsets = MediaQuery.of(context).viewInsets;
      while (mounted && MediaQuery.of(context).viewInsets == edgeInsets) {
        await new Future.delayed(const Duration(milliseconds: 10));
      }
    }

    return;
  }

  Future<Null> _ensureVisible() async {
    // Wait for the keyboard to come into view
    await Future.any([
      new Future.delayed(const Duration(milliseconds: 300)),
      _keyboardToggled()
    ]);

    // No need to go any further if the node has not the focus
    if (!widget.focusNode.hasFocus) {
      return;
    }

    // Find the object which has the focus
    final RenderObject object = context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);

    // If we are not working in a Scrollable, skip this routine
    if (viewport == null) {
      return;
    }

    // Get the Scrollable state (in order to retrieve its offset)
    ScrollableState scrollableState = Scrollable.of(context);
    assert(scrollableState != null);

    // Get its offset
    ScrollPosition position = scrollableState.position;
    double alignment;

    if (position.pixels > viewport.getOffsetToReveal(object, 0.0).offset) {
      // Move down to the top of the viewport
      alignment = 0.0;
    } else if (position.pixels <
        viewport.getOffsetToReveal(object, 1.0).offset) {
      // Move up to the bottom of the viewport
      alignment = 1.0;
    } else {
      // No scrolling is necessary to reveal the child
      return;
    }
    widget.scrollInProgress();
    position
        .ensureVisible(
          object,
          alignment: alignment,
          duration: widget.duration,
          curve: widget.curve,
        )
        .then((_) => widget.scrollDone);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
