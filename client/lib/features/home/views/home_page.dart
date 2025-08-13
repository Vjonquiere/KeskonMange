import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/home/viewmodels/coming_recipes_viewmodel.dart';
import 'package:client/features/home/viewmodels/home_page_viewmodel.dart';
import 'package:client/features/recipe_calendar/viewmodels/calendar_viewmodel.dart';
import 'package:client/features/recipe_calendar/views/calendar_page.dart';
import 'package:client/features/recipe_planning/views/planned_recipes_page.dart';
import 'package:client/features/user_creations/views/my_creations_page.dart';
import 'package:client/features/recipe_search/views/search_page.dart';
import 'package:client/features/user_profile/views/user_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../viewmodels/today_meal_viewmodel.dart';
import '../widgets/coming_recipes.dart';
import '../../../utils/app_icons.dart';
import '../widgets/today_meal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageViewModel(),
      child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: AppColors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => UserPage()));
                    },
                    text: 'pen'),
                CustomButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyCreationsPage()));
                    },
                    text: 'book'),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  child: SvgPicture.asset(AppIcons.getIcon('search')),
                ),
                CustomButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlannedRecipesPage()));
                    },
                    text: 'upload'),
                CustomButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                                create: (context) => CalendarViewModel(),
                                child: CalendarPage(),
                              )));
                    },
                    text: 'calendar'),
              ],
            ),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                home(context),
              ],
            ),
          )),
    );
  }

  Widget home(context) {
    return Center(
      child: Column(
        children: [
          ChangeNotifierProvider(
              create: (context) => TodayMealViewModel(), child: TodayMeal()),
          const CustomDivider(important: true, color: AppColors.pink),
          Center(
            child: ChangeNotifierProvider(
              create: (context) => ComingRecipesViewModel(),
              child: ComingRecipes(),
            ),
          )
        ],
      ),
    );
  }
}
