import 'package:beast/src/app/constants/config.dart';
import 'package:beast/src/ui/views/search/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      onModelReady: (SearchViewModel model) => model.initStateFunc(
        contextFunc: context,
      ),
      builder: (
        BuildContext context,
        SearchViewModel model,
        Widget child,
      ) {
        return Scaffold(
          backgroundColor: Config.blackColor,
          appBar: model.searchAppBar(),
          body: model.buildSuggestions(),
        );
      },
    );
  }
}
