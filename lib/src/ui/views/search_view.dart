import 'package:beast/src/constants/config.dart';
import 'package:beast/src/viewmodels/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModel: SearchViewModel(),
      onModelReady: (model) => model.initStateFunc(
        contextFunc: context,
      ),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          appBar: model.searchAppBar(),
          body: model.buildSuggestions(),
        );
      },
    );
  }
}
