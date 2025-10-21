import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

typedef ViewModelBuilder<T> =
Widget Function(BuildContext context, T viewModel, Widget? child);

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final T Function() viewModelBuilder;
  final ViewModelBuilder<T> builder;
  final Function(T)? onModelReady;
  final bool autoDispose;
  final bool padding;
  final bool useSelector;

  const BaseView({
    Key? key,
    required this.viewModelBuilder,
    required this.builder,
    this.onModelReady,
    this.autoDispose = true,
    this.padding = true,
    this.useSelector = false,
  }) : super(key: key);

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  late T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModelBuilder();
    widget.onModelReady?.call(viewModel);
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: _buildSafeAreaPadding(context),
    );
  }

  Widget _buildSafeAreaPadding(BuildContext context) {
    if (Platform.isIOS) {
      return SafeArea(child: Consumer<T>(builder: widget.builder));
    } else {
      return Padding(
        padding: widget.padding
            ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
            : EdgeInsets.zero,
        child: widget.useSelector
            ? Builder(
          builder: (context) {
            final vm = Provider.of<T>(context, listen: false);
            return widget.builder(context, vm, null);
          },
        )
            : Consumer<T>(builder: widget.builder),
      );
    }
  }
}
