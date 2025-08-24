import 'package:client/core/widgets/colorful_text_builder.dart';
import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/features/user_creations/views/my_creations_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';

class DeleteBookDialog extends StatelessWidget {
  VoidCallback _onDeleteBookPressed;

  DeleteBookDialog(this._onDeleteBookPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorfulTextBuilder("Delete this book ?", 25, true).getWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(
              "If you delete this book, you wouldn't be able to retreive it. If you've shared it with people, they couldn't have access to it anymore."),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
