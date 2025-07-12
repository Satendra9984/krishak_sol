enum PaymentMode {
  cash('cash'),
  online('online');

  const PaymentMode(this.value);

  final String value;

  @override
  String toString() => value;

  static PaymentMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cash':
        return PaymentMode.cash;
      case 'online':
        return PaymentMode.online;
      default:
        throw ArgumentError('Invalid PaymentMode: $value');
    }
  }

  // Alternative method that returns null instead of throwing
  static PaymentMode? fromStringOrNull(String value) {
    try {
      return fromString(value);
    } catch (e) {
      return null;
    }
  }
}
