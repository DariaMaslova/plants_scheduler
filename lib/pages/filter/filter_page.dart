import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:plants_scheduler/api/model/filter.dart';
import 'package:plants_scheduler/core/pair.dart';
import 'package:plants_scheduler/generated/l10n.dart';
import 'package:plants_scheduler/main.dart';
import 'package:plants_scheduler/pages/common/models/filter.dart';

class FilterPage extends StatefulWidget {
  final FilterParams filterParams;

  const FilterPage({Key key, this.filterParams}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FilterState();
  }
}

class _FilterState extends State<FilterPage> {
  FilterParams _filterParams;

  TextEditingController _heightMinController;
  TextEditingController _heightMaxController;

  @override
  void initState() {
    _filterParams = widget.filterParams;
    final initialHeight = _getHeight();
    final Function onHeightTextChanged = () => _onHeightRangeChanged(
          int.parse(_heightMinController.text, onError: (_) => 0),
          int.parse(_heightMaxController.text, onError: (_) => 0),
        );
    _heightMinController =
        TextEditingController(text: initialHeight.first.toString())
          ..addListener(onHeightTextChanged);
    _heightMaxController =
        TextEditingController(text: initialHeight.second.toString())
          ..addListener(onHeightTextChanged);
    super.initState();
  }

  bool _getIsEdible() {
    final attribute =
        _filterParams.attributes[FilterAttributeKeys.FILTER_EDIBLE];
    return attribute is BooleanFilterAttribute && (attribute.value ?? false);
  }

  Set<String> _getSelectedMonths() {
    final attribute =
        _filterParams.attributes[FilterAttributeKeys.FILTER_BLOOM_MONTHS];
    return attribute is MultiChoiceFilterAttribute
        ? (attribute.values ?? HashSet())
        : HashSet();
  }

  Pair<int, int> _getRangedAttribute(String key,
      {int defaultMin: 0, int defaultMax: 0}) {
    final attribute = _filterParams.attributes[key];

    return attribute is RangeFilterAttribute
        ? (Pair(
            attribute.minValue ?? defaultMin, attribute.maxValue ?? defaultMax))
        : Pair(defaultMin, defaultMax);
  }

  Pair<int, int> _getLightLevel() => _getRangedAttribute(
        FilterAttributeKeys.FILTER_LIGHT,
        defaultMin: 0,
        defaultMax: 10,
      );

  Pair<int, int> _getHeight() =>
      _getRangedAttribute(FilterAttributeKeys.FILTER_MAX_HEIGHT);

  _onEdibleCheckedChanged(bool isChecked) => setState(
        () {
          _filterParams = _filterParams.withAttribute(
            FilterAttributeKeys.FILTER_EDIBLE,
            BooleanFilterAttribute(FilterAttributeKeys.FILTER_EDIBLE,
                value: isChecked),
          );
        },
      );

  _onMonthSelectedChanged(String month, bool isSelected) {
    final selectedMonths = HashSet<String>.from(_getSelectedMonths());
    if (isSelected) {
      selectedMonths.add(month);
    } else {
      selectedMonths.remove(month);
    }
    setState(() {
      _filterParams = _filterParams.withAttribute(
        FilterAttributeKeys.FILTER_BLOOM_MONTHS,
        MultiChoiceFilterAttribute(
          FilterAttributeKeys.FILTER_BLOOM_MONTHS,
          values: selectedMonths,
        ),
      );
    });
  }

  _onRangedAttributeChanged(String key, int left, int right) => setState(
        () {
          _filterParams = _filterParams.withAttribute(
            key,
            RangeFilterAttribute(
              key,
              minValue: left,
              maxValue: right,
            ),
          );
        },
      );

  _onLightRangeChanged(int left, int right) => _onRangedAttributeChanged(
        FilterAttributeKeys.FILTER_LIGHT,
        left,
        right,
      );

  _onHeightRangeChanged(int left, int right) => _onRangedAttributeChanged(
        FilterAttributeKeys.FILTER_MAX_HEIGHT,
        left,
        right,
      );

  _save() {
    AppNavigator.of(context).pop(_filterParams);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            AppNavigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.done),
            ),
            onTap: _save,
          )
        ],
        title: Text(S.of(context).filterTitle),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: [
          _FilterTitle(
            S.of(context).filterFilterBloomMonth,
            applyTopLeading: false,
          ),
          _MonthsTile(
            _getSelectedMonths(),
            onSelectedChanged: _onMonthSelectedChanged,
          ),
          _FilterTitle(S.of(context).filterFilterLight),
          _LightLevelTile(
            _getLightLevel(),
            onRangeChanged: _onLightRangeChanged,
          ),
          _FilterTitle(S.of(context).filterFilterMaxHeight),
          _HeightTile(
            values: _getHeight(),
            leftController: _heightMinController,
            rightController: _heightMaxController,
          ),
          _EdibleTile(
            _getIsEdible(),
            onCheckedChanged: _onEdibleCheckedChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterTitle extends StatelessWidget {
  final String title;
  final bool applyStartLeading;
  final bool applyTopLeading;

  const _FilterTitle(
    this.title, {
    Key key,
    this.applyStartLeading = true,
    this.applyTopLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: applyTopLeading ? 16.0 : 0,
          left: applyStartLeading ? 16.0 : 0.0,
          right: 16.0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w800,
            fontSize: 18.0),
      ),
    );
  }
}

class _EdibleTile extends StatelessWidget {
  final bool isEdible;
  final Function(bool isCkecked) onCheckedChanged;

  const _EdibleTile(this.isEdible, {Key key, this.onCheckedChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        child: Row(
          children: [
            Checkbox(value: isEdible, onChanged: onCheckedChanged),
            _FilterTitle(
              S.of(context).filterFilterEdible,
              applyStartLeading: false,
              applyTopLeading: false,
            ),
          ],
        ),
        onTap: () => onCheckedChanged?.call(!isEdible),
      ),
    );
  }
}

class _MonthsTile extends StatelessWidget {
  static final _formatMonth = DateFormat("MMMM");
  final Set<String> selectedMonths;
  final Function(String month, bool isSelected) onSelectedChanged;

  const _MonthsTile(this.selectedMonths, {Key key, this.onSelectedChanged})
      : super(key: key);

  String _toShortName(int month) {
    return FilterAttributeValues.MONTHS[month];
  }

  List<int> get _months => List<int>.generate(10, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Wrap(
        spacing: 8.0,
        children: _months.map((month) {
          final isSelected = selectedMonths.contains(_toShortName(month));
          return FilterChip(
            label: Text(
              _formatMonth.format(DateTime(197, month)),
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
            onSelected: (isSelected) =>
                onSelectedChanged?.call(_toShortName(month), isSelected),
            selected: isSelected,
            selectedColor: Theme.of(context).accentColor,
            checkmarkColor: Colors.white,
          );
        }).toList(),
      ),
    );
  }
}

class _LightLevelTile extends StatelessWidget {
  final Pair<int, int> values;
  final Function(int left, int right) onRangeChanged;

  const _LightLevelTile(this.values, {Key key, this.onRangeChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(S.of(context).filterValueNoLight),
          Expanded(
            child: RangeSlider(
              values: RangeValues(
                  values.first.toDouble(), values.second.toDouble()),
              min: 0.0,
              max: 10.0,
              divisions: 10,
              onChanged: (newValues) => onRangeChanged?.call(
                  newValues.start.toInt(), newValues.end.toInt()),
            ),
          ),
          Text(S.of(context).filterValueHighLight),
        ],
      ),
    );
  }
}

class _HeightTile extends StatelessWidget {
  final Pair<int, int> values;
  final TextEditingController leftController;
  final TextEditingController rightController;

  const _HeightTile({
    Key key,
    this.values,
    this.leftController,
    this.rightController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(S.of(context).filterFiledMin),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "0"),
                controller: leftController,
              ),
            ),
          ),
          Text(S.of(context).filterFieldMax),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(hintText: "0"),
                keyboardType: TextInputType.number,
                controller: rightController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
