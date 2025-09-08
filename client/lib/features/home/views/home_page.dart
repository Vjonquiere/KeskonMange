import 'package:client/core/widgets/custom_buttons.dart';
import 'package:client/core/widgets/custom_dividers.dart';
import 'package:client/features/home/viewmodels/coming_recipes_viewmodel.dart';
import 'package:client/features/home/viewmodels/home_page_viewmodel.dart';
import 'package:client/features/ingredient_creation/viewmodels/ingredient_viewmodel.dart';
import 'package:client/features/ingredient_creation/views/ingredient_creation.dart';
import 'package:client/features/recipe_calendar/viewmodels/calendar_viewmodel.dart';
import 'package:client/features/recipe_calendar/views/calendar_page.dart';
import 'package:client/features/recipe_planning/viewmodels/recipe_planning_viewmodel.dart';
import 'package:client/features/recipe_planning/views/recipe_planning_page.dart';
import 'package:client/features/recipe_search/viewmodels/search_page_viewmodel.dart';
import 'package:client/features/user_creations/views/my_creations_page.dart';
import 'package:client/features/recipe_search/views/search_page.dart';
import 'package:client/features/user_profile/views/user_page.dart';
import 'package:client/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../user_creations/viewmodels/my_creations_viewmodel.dart';
import '../viewmodels/today_meal_viewmodel.dart';
import '../widgets/coming_recipes.dart';
import '../../../utils/app_icons.dart';
import '../widgets/today_meal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageViewModel>(
      create: (BuildContext context) => HomePageViewModel(),
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: AppColors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CustomButton(
                iconSize: 32,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<UserPage>(
                        builder: (BuildContext context) => const UserPage()),
                  );
                },
                text: 'pen',
              ),
              CustomButton(
                iconSize: 32,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<MyCreationsPage>(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider<MyCreationViewModel>(
                        create: (BuildContext context) => MyCreationViewModel(),
                        child: const MyCreationsPage(),
                      ),
                    ),
                  );
                },
                text: 'book',
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<SearchPage>(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider<SearchPageViewModel>(
                        create: (BuildContext context) => SearchPageViewModel(),
                        child: const SearchPage(),
                      ),
                    ),
                  );
                },
                child: SvgPicture.asset(AppIcons.getIcon('search')),
              ),
              CustomButton(
                iconSize: 32,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<RecipePlanningPage>(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider<RecipePlanningViewModel>(
                        create: (BuildContext context) =>
                            RecipePlanningViewModel(),
                        child: RecipePlanningPage(),
                      ),
                    ),
                  );

                  /*
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlannedRecipesPage()));*/
                },
                text: 'upload',
              ),
              CustomButton(
                iconSize: 32,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<CalendarPage>(
                      builder: (BuildContext context) =>
                          ChangeNotifierProvider<CalendarViewModel>(
                        create: (BuildContext context) => CalendarViewModel(),
                        child: const CalendarPage(),
                      ),
                    ),
                  );
                },
                text: 'calendar',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              home(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget home(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ChangeNotifierProvider<TodayMealViewModel>(
            create: (BuildContext context) => TodayMealViewModel(),
            child: const TodayMeal(),
          ),
          const CustomDivider(important: true, color: AppColors.pink),
          Center(
            child: ChangeNotifierProvider<ComingRecipesViewModel>(
              create: (BuildContext context) => ComingRecipesViewModel(),
              child: const ComingRecipes(),
            ),
          ),
        ],
      ),
    );
  }
}
