class AppIcons {
  // Define static constants for your icons
  static const String search = 'assets/icons/search.svg';
  static const String gluten = 'assets/icons/allergens/gluten.svg';

  // A map to store icon references for easy lookup
  static const Map<String, String> _iconMap = {
    'search': search,
    'gluten': gluten,
  };

  // Method to get an icon path by its key
  static String getIcon(String element) {
    return _iconMap[element] ?? 'Icon not found'; // Return a fallback message if the key doesn't exist
  }
}
