import 'package:client/features/recipe_search/widgets/preparation_time_filer/preparation_time_filter_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/features/recipe_search/model/preparation_time_filter.dart'
    as model;

class PreparationTimeFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PreparationTimeFilterViewModel(),
      child: _PreparationTimeFilter(),
    );
  }
}

class _PreparationTimeFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PreparationTimeFilterViewModel viewModel = Provider.of(context);
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
              Navigator.of(context).pop(model.PreparationTimeFilter(
                  preparationTime: viewModel.currentTime.round()));
            },
            child: Text("Apply"))
      ],
    );
  }
}
