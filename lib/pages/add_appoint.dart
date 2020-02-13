import 'dart:async';

import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/data/api_base.dart';
import 'package:appoint/utils/calendar.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/pages/select_period.dart';
import 'package:appoint/utils/logger.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/settings_vm.dart';
import 'package:appoint/view_models/user_vm.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/dialog.dart' as appointNs;
import 'package:appoint/widgets/icon_circle_gradient.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/pages/select_company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddAppoint extends StatefulWidget {
  final Appoint appoint;

  ///#no-time: used to create appoint with companies pre-selected (e.g. from company favorites)
  final Company company;
  final bool isEditing;

  AddAppoint({
    Key key,
    this.isEditing = false,
    this.appoint,
    this.company,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddAppointState();
  }
}

class AddAppointState extends State<AddAppoint>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final Logger logger = getLogger("AddAppoint");
  final _appointFormKey = GlobalKey<FormState>();

  String _title;
  Company _company;
  Period _period;
  String _description;

  bool get isEditing => widget.isEditing;

  bool hideKeyboardEnabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      logger.d("isEditing");

      _company = widget.appoint.company;
      _title = widget.appoint.title;
      _period = widget.appoint.period;
      _description = widget.appoint.description;

      _titleController.text = _title;
    } else if (widget.company != null) {
      _company = widget.company;
    }

    _titleController.addListener(onTitleChange);
    _descriptionController.addListener(onDescriptionChange);
    WidgetsBinding.instance.addObserver(this);
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
    logger.d("build");

    return Scaffold(
      appBar: buildNavBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Padding(
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
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        _firstCard(),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text("nächsten freien Termin finden"),
                          onPressed: _company == null || _period != null
                              ? null
                              : () {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  final store =
                                      StoreProvider.of<AppState>(context)
                                          .state
                                          .userViewModel;
                                  final _api = ApiBase();
                                  _api.token = store.token;
                                  _api.userId = store.user.id;

                                  _api
                                      .getNextPeriod(_company.id)
                                      .then((period) {
                                    if (period != null) {
                                      _period = period;
                                    } else {
                                      print("failed to get next period");
                                    }

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  });
                                },
                        ),
                        _buildInformationCard(),
                      ],
                    ),
                    if (_isLoading) CupertinoActivityIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavBar() {
    logger.d("build NavBar");

    return NavBar(
      isEditing ? "Bearbeiten" : "Neuer Termin",
      height: 57,
      leadingWidget: IconButton(
        icon: Icon(Icons.close),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      trailing: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, vm) {
          logger.d("build store connector navBar");
          return CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text(
              isEditing ? "Speichern" : "Erstellen",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isValid() ? Color(0xff09c199) : null),
            ),
            onPressed: _isValid()
                ? () {
                    setState(() {
                      _isLoading = true;
                    });

                    final appoint = Appoint(
                      id: isEditing ? widget.appoint.id : null,
                      title: _title,
                      company: _company,
                      period: _period,
                      description: _description ?? "",
                    );

                    final api = ApiBase();
                    api.token = vm.userViewModel.token;
                    api.userId = vm.userViewModel.user.id;

                    if (!isEditing) {
                      //save new
                      api.postAppointment(appoint).then((success) {
                        if (success) {
                          vm.createOrUpdateAppoint(Appoint(
                            id: isEditing ? widget.appoint.id : null,
                            title: _title,
                            company: _company,
                            period: _period,
                            description: _description,
                          ));

                          if (vm.settingsViewModel
                                      .settings[kSettingsCalendarIntegration] ==
                                  true &&
                              vm.settingsViewModel
                                      .settings[kSettingsSaveToCalendar] ==
                                  true) {
                            //calendar integration
                            Calendar()
                                .createNativeCalendarEvent(
                                    vm.settingsViewModel
                                        .settings[kSettingsCalendarId],
                                    _period.start,
                                    _title,
                                    _period.duration,
                                    _description,
                                    _company)
                                .then((res) {
                              setState(() {
                                _isLoading = false;
                              });

                              if (res) {
                                //added to calendar
                                _showCreationSucceedDialog("Termin erstellt",
                                    "Termin wurde erfolgreich erstellt und in den Kalender übertragen");
                              } else {
                                print(
                                    "failed to add appoint to local calendar");
                                //TODO: info message to user
                                Navigator.pop(context);
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            //no calendar integration. Still show success popup
                            _showCreationSucceedDialog(
                              "Termin erstellt",
                              "Termin wurde erfolgreich erstellt und in den Kalender übertragen",
                            );
                          }
                        } else {
                          setState(() {
                            _isLoading = false;
                          });

                          print("failed");
                        }
                      });
                    } else {
                      //edited an existing appoint
                      api.updateAppointment(appoint).then((succeed) {
                        if (succeed) {
                          setState(() {
                            _isLoading = false;
                          });

                          vm.createOrUpdateAppoint(Appoint(
                            id: isEditing ? widget.appoint.id : null,
                            title: _title,
                            company: _company,
                            period: _period,
                            description: _description,
                          ));

                          _showCreationSucceedDialog("Termin aktualisiert",
                              "Termin wurde erfolgreich aktualisiert");
                        } else {
                          //TODO: info message to user
                          setState(() {
                            _isLoading = false;
                          });

                          print("failed to update appoint (API)");
                        }
                      });
                    }
                  }
                : null,
          );
        },
      ),
    );
  }

  _showCreationSucceedDialog(String title, String information) {
    showDialog(
        context: context,
        builder: (context) {
          return appointNs.Dialog(
            canClose: false,
            title: title,
            information: information,
            informationTextSize: 18,
          );
        });

    Future.delayed(Duration(seconds: 2), () {
      //first, pop dialog, then pop add_appoint
      Navigator.of(context).pop();

      Navigator.pop(context);
    });
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
        elevation: 1,
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
            Text("Zeitraum"),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: _company == null
                  ? Colors.grey[350]
                  : Theme.of(context).accentColor,
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
            Text("Unternehmen"),
            Icon(Icons.arrow_forward_ios,
                size: 18, color: Theme.of(context).accentColor),
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
            padding: EdgeInsets.only(left: 15),
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

  Widget _buildInformationCard() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: EnsureVisibleWhenFocused(
            scrollDone: () => scrollDone,
            scrollInProgress: () => scrollInProgress,
            focusNode: _descriptionFocus,
            child: TextFormField(
              focusNode: _descriptionFocus,
              controller: _descriptionController,
              minLines: 1,
              maxLines: 6,
              maxLength: 256,
              decoration: InputDecoration(
                  hintText: "Informationen",
                  suffixIcon: _descriptionController.text.isNotEmpty
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            CupertinoIcons.clear,
                            size: 32,
                            color: Colors.grey,
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
  final UserViewModel userViewModel;
  final Function(Appoint appoint) createOrUpdateAppoint;
  final SettingsViewModel settingsViewModel;

  _ViewModel({
    this.createOrUpdateAppoint,
    this.settingsViewModel,
    this.userViewModel,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      createOrUpdateAppoint: (Appoint appoint) =>
          store.dispatch(CreateOrUpdateAppointAction(appoint)),
      settingsViewModel: store.state.settingsViewModel,
      userViewModel: store.state.userViewModel,
    );
  }

  @override
  int get hashCode => userViewModel.hashCode ^ settingsViewModel.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          settingsViewModel == other.settingsViewModel &&
          userViewModel == other.userViewModel;
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
