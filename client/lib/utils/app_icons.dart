class AppIcons {
  // Basic icons
  static const String search = 'assets/icons/search.svg';
  static const String add = 'assets/icons/add.svg';
  static const String back = 'assets/icons/back.svg';
  static const String bell = 'assets/icons/bell.svg';
  static const String bin = 'assets/icons/bin.svg';
  static const String calendar = 'assets/icons/calendar.svg';
  static const String delete = 'assets/icons/delete.svg';
  static const String help = 'assets/icons/help.svg';
  static const String pen = 'assets/icons/pen.svg';
  static const String todo = 'assets/icons/to-do_list.svg';
  static const String upload = 'assets/icons/upload.svg';
  static const String next = 'assets/icons/next.svg';
  static const String previous = 'assets/icons/previous.svg';
  static const String toDoList = 'assets/icons/to_do_list.svg';
  static const String chefHat = 'assets/icons/chef_hat.svg';
  static const String oven = 'assets/icons/oven.svg';

  //Allergens
  static const String gluten = 'assets/icons/allergens/gluten.svg';
  static const String fish = 'assets/icons/allergens/fish.svg';
  static const String peanuts = 'assets/icons/allergens/peanuts.svg';
  static const String celery = 'assets/icons/allergens/celery.svg';
  static const String sulfates = 'assets/icons/allergens/sulfates.svg';
  static const String lupin = 'assets/icons/allergens/celery.svg';
  static const String eggs = 'assets/icons/allergens/eggs.svg';
  static const String sesame = 'assets/icons/allergens/celery.svg';
  static const String mustard = 'assets/icons/allergens/mustard.svg';
  static const String mollusks = 'assets/icons/allergens/mollusks.svg';
  static const String crustaceans = 'assets/icons/allergens/crustaceans.svg';
  static const String soy = 'assets/icons/allergens/celery.svg';
  static const String nuts = 'assets/icons/allergens/nuts.svg';
  static const String milk = 'assets/icons/allergens/milk.svg';

  //Recipe book
  static const String book = 'assets/icons/recipe_book/book.svg';
  static const String private = 'assets/icons/recipe_book/private.svg';
  static const String public = 'assets/icons/recipe_book/public.svg';
  static const String trash = 'assets/icons/recipe_book/trash.svg';

  //Recipes
  static const String cake = 'assets/icons/recipes/cake.svg';
  static const String prep = 'assets/icons/recipes/cooking_preparation.svg';
  static const String list = 'assets/icons/recipes/list_ingredients.svg';
  static const String meal = 'assets/icons/recipes/meal.svg';
  static const String timer = 'assets/icons/recipes/timer.svg';
  static const String veggie = 'assets/icons/recipes/veggie.svg';

  //Weather
  static const String cloud = 'assets/icons/weather/cloud.svg';
  static const String fog = 'assets/icons/weather/fog.svg';
  static const String rain = 'assets/icons/weather/rain.svg';
  static const String rainAndSun = 'assets/icons/weather/rainAndSun.svg';
  static const String snow = 'assets/icons/weather/snow.svg';
  static const String sunny = 'assets/icons/weather/sunny.svg';
  static const String thunder = 'assets/icons/weather/thunder.svg';
  static const String tornado = 'assets/icons/weather/tornado.svg';
  static const String wind = 'assets/icons/weather/wind.svg';

  static const String placeholder = 'assets/icons/place_holder.png';
  static const String placeholderSquare =
      'assets/icons/place_holder_square.png';

  // A map to store icon references for easy lookup
  static const Map<String, String> _iconMap = <String, String>{
    // Basic icons
    'search': search,
    'add': add,
    'back': back,
    'bell': bell,
    'bin': bin,
    'calendar': calendar,
    'delete': delete,
    'help': help,
    'pen': pen,
    'todo': todo,
    'upload': upload,
    'next': next,
    'previous': previous,
    'toDoList': toDoList,
    'chef_hat': chefHat,
    'oven': oven,

    // Allergens
    'Gluten': gluten,
    "Fish": fish,
    "Peanuts": peanuts,
    "Celery": celery,
    "Sulfates": sulfates,
    "Lupin": lupin,
    "Eggs": eggs,
    'Sesame': sesame,
    'Mustard': mustard,
    "Mollusks": mollusks,
    "Crustaceans": crustaceans,
    "Soy": soy,
    "Nuts": nuts,
    "Milk": milk,

    // Recipe book
    'book': book,
    'private': private,
    'public': public,
    'trash': trash,

    // Recipes
    'cake': cake,
    'prep': prep,
    'list': list,
    'meal': meal,
    'timer': timer,
    'veggie': veggie,

    // Weather
    'cloud': cloud,
    'fog': fog,
    'rain': rain,
    'rainAndSun': rainAndSun,
    'snow': snow,
    'sunny': sunny,
    'thunder': thunder,
    'tornado': tornado,
    'wind': wind,

    'placeholder': placeholder,
    'placeholder_square': placeholderSquare,
  };

  // Method to get an icon path by its key
  static String getIcon(String element) {
    return _iconMap[element] ??
        'Icon not found'; // Return a fallback message if the key doesn't exist
  }
}
