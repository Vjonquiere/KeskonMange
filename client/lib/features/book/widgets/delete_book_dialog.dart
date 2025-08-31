import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';

import '../../../l10n/app_localizations.dart';

class DeleteBookDialog extends StatelessWidget {
  final VoidCallback _onDeleteBookPressed;

  const DeleteBookDialog(this._onDeleteBookPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ColorfulTextBuilder(AppLocalizations.of(context)!.book_delete, 25, true)
            .getWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(AppLocalizations.of(context)!.book_delete_warning),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CustomButton(
              text: "back",
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconSize: 32,
            ),
            CustomButton(
              text: "trash",
              onPressed: () {
                _onDeleteBookPressed();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              iconSize: 32,
              color: AppColors.red,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
