enum PaymentStatus {
  pending('pending'),
  completed('completed'),
  failed('failed');

  const PaymentStatus(this.value);

  final String value;

  @override
  String toString() => value;

  static PaymentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      default:
        throw ArgumentError('Invalid PaymentStatus: $value');
    }
  }

  // Alternative method that returns null instead of throwing
  static PaymentStatus? fromStringOrNull(String value) {
    try {
      return fromString(value);
    } catch (e) {
      return null;
    }
  }
}
