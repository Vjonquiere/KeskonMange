import 'package:client/model/book/preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';

class BookPreviewWidget extends StatelessWidget {
  final BookPreview _preview;

  BookPreviewWidget(this._preview);

  Widget recipeImage() {
    return Card.filled(
      color: AppColors.beige,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(
          image: AssetImage(AppIcons.getIcon("placeholder_square")),
          width: 64,
          height: 64,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10.0),
        recipeImage(),
        const SizedBox(width: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _preview.name,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.getIcon(_preview.public ? "public" : "private"),
                  width: 16,
                ),
                const SizedBox(width: 10.0),
                Text(_preview.public ? "public" : "private"),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
