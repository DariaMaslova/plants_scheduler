class Pair<T, R> {
  final T first;
  final R second;

  Pair(this.first, this.second);

  @override
  bool operator ==(Object other) {
    return other is Pair<T, R> &&
        other.first == first &&
        other.second == second;
  }

  @override
  int get hashCode => first.hashCode + second.hashCode;

}
