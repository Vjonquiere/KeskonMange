class AppIcons {
  // Define static constants for your icons
  static const String search = 'icons/search.svg';
  static const String gluten = 'icons/allergens/gluten.svg';
  static const String fish = 'icons/allergens/fish.svg';
  static const String peanuts = 'icons/allergens/peanuts.svg';
  static const String celery = 'icons/allergens/celery.svg';
  static const String sulfates = 'icons/allergens/sulfates.svg';
  static const String lupin = 'icons/allergens/celery.svg';
  static const String eggs = 'icons/allergens/eggs.svg';
  static const String sesame = 'icons/allergens/celery.svg';
  static const String mustard = 'icons/allergens/mustard.svg';
  static const String mollusks = 'icons/allergens/mollusks.svg';
  static const String crustaceans = 'icons/allergens/crustaceans.svg';
  static const String soy = 'icons/allergens/celery.svg';
  static const String nuts = 'icons/allergens/nuts.svg';
  static const String milk = 'icons/allergens/milk.svg';

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
