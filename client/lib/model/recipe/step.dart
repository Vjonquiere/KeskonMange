class Step {
  String title;
  String stepText;

  Step(this.title, this.stepText);

  @override
  String toString() {
    return "step => title: $title | step: $stepText";
  }

  factory Step.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {"title": final String title, "step": final String step} =>
        Step(title, step),
      _ => throw FormatException("Can't load step")
    };
  }
}
