#library('commons');

class Key <T extends Hashable> implements Hashable {
  final T _value;
  const Key(T this._value);
  
  bool operator == (Hashable other) {
    if(other != null && other is Key<T>) {
      return hashCode() == other.hashCode();
    }
    return false;
  }
  
  int hashCode() {
    return _value.hashCode();
  }
  
  String toString() {
    if(_value != null) {
      return _value.toString();
    }
    return '';
  }
}