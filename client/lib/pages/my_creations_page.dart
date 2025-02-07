import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../custom_widgets/colorful_text_builder.dart';
import '../custom_widgets/custom_buttons.dart';
import '../utils/app_icons.dart';
import 'home_page.dart';
import 'new_book_page.dart';

class MyCreationsPage extends StatefulWidget {
  @override
  State<MyCreationsPage> createState() => _MyCreationsPageState();
}

class _MyCreationsPageState extends State<MyCreationsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Recipe Books",
              ),
              Tab(
                text: " Recipes",
              ),
            ],
          ),
          title: title(),
        ),
        body: TabBarView(
          children: [
            recipeBooks(),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }

  Widget recipeBooks() {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        recipeBook("All saved recipes", "public"),
        CustomButton(
          text: "add",
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NewBookPage()));
          },
          scaleSize: 0.75,
        ),
      ],
    );
  }

  Widget recipeBook(String title, String status) {
    return Row(
      children: [
        const SizedBox(width: 10.0),
        recipeImage(),
        const SizedBox(width: 10.0),
        Column(
          children: [
            Text(title),
            recipeBookPrivacy(status),
          ],
        ),
      ],
    );
  }

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

  Widget recipeBookPrivacy(String context) {
    if (context == "public") {
      return Row(
        children: [
          SvgPicture.asset(
            AppIcons.getIcon("public"),
            width: 16,
          ),
          const SizedBox(width: 10.0),
          const Text("public"),
        ],
      );
    }
    return Row(
      children: [
        SvgPicture.asset(
          AppIcons.getIcon("private"),
          width: 16,
        ),
        const SizedBox(width: 10.0),
        const Text("private"),
      ],
    );
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ColorfulTextBuilder("My creations!", 30, true).getWidget(),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            AppIcons.getIcon("help"),
            width: 32,
          ),
        )
      ],
    );
  }
}
