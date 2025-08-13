class Step {
  String title;
  String stepText;

  Step(this.title, this.stepText);

  @override
  String toString() {
    return "step => title: $title | step: $stepText";
  }
}
