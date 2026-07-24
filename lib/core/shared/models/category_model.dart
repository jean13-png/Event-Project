
class CategoryModel {
  final String id;
  final String label;
  final String iconName;
  final int sortOrder;

  CategoryModel({
    required this.id,
    required this.label,
    required this.iconName,
    this.sortOrder = 0,
  });

  static const List<CategoryModel> all = [
    CategoryModel(id: 'concert', label: 'Concert', iconName: 'music', sortOrder: 1),
    CategoryModel(id: 'soiree', label: 'Soirée', iconName: 'moon-stars', sortOrder: 2),
    CategoryModel(id: 'sport', label: 'Sport', iconName: 'trophy', sortOrder: 3),
    CategoryModel(id: 'culture', label: 'Culture', iconName: 'palette', sortOrder: 4),
    CategoryModel(id: 'gastronomie', label: 'Gastronomie', iconName: 'tools-kitchen-2', sortOrder: 5),
    CategoryModel(id: 'formation', label: 'Formation', iconName: 'microphone-2', sortOrder: 6),
  ];

  static CategoryModel? byId(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } on StateError {
      return null;
    }
  }
}
