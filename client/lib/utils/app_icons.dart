class AppIcons {
  // Define static constants for your icons
  static const String search = 'assets/icons/search.svg';
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

  // A map to store icon references for easy lookup
  static const Map<String, String> _iconMap = {
    'search': search,
    'Gluten': gluten,
    "Fish" : fish,
    "Peanuts" : peanuts,
    "Celery" : celery,
    "Sulfates" : sulfates,
    "Lupin" : lupin,
    "Eggs" : eggs,
    'Sesame' : sesame,
    'Mustard' : mustard,
    "Mollusks" : mollusks,
    "Crustaceans" : crustaceans,
    "Soy" : soy,
    "Nuts" : nuts,
    "Milk" : milk,
  };

  // Method to get an icon path by its key
  static String getIcon(String element) {
    return _iconMap[element] ?? 'Icon not found'; // Return a fallback message if the key doesn't exist
  }
}
