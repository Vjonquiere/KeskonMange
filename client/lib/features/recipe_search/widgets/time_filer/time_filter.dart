import 'package:client/features/recipe_search/widgets/time_filer/time_filter_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/features/recipe_search/model/time_filter.dart' as model;

class TimeFilter extends StatelessWidget {
  final model.TimeFilter filter;

  TimeFilter({required this.filter});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TimeFilterViewModel(filter),
      child: _PreparationTimeFilter(),
    );
  }
}

class _PreparationTimeFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TimeFilterViewModel viewModel = Provider.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
          value: viewModel.currentTime,
          onChanged: viewModel.updateCurrentTime,
          min: 5.0,
          max: 180.0,
        ),
        Text(viewModel.convertedCurrentTime()),
        OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(viewModel.getFilter());
            },
            child: Text("Apply"))
      ],
    );
  }
}
