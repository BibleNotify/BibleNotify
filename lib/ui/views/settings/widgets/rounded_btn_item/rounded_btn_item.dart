import 'package:biblenotify/ui/views/settings/widgets/rounded_btn_item/rounded_btn_item_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RoundedBtnItem extends StackedView<RoundedBtnItemModel> {
  const RoundedBtnItem({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final String icon;
  final String tooltip;
  final Function()? onTap;

  @override
  Widget builder(
    BuildContext context,
    RoundedBtnItemModel viewModel,
    Widget? child,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(60.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: ImageIcon(
            AssetImage(icon),
            size: 20.0,
          ),
        ),
      ),
    );
  }

  @override
  RoundedBtnItemModel viewModelBuilder(
    BuildContext context,
  ) =>
      RoundedBtnItemModel();
}
