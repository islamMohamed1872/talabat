class WalletDetails {
  final double balance;
  final int completedOrders;
  final int refundedOrders;
  final int cancelledOrders;
  final String note;

  WalletDetails({
    required this.balance,
    required this.completedOrders,
    required this.refundedOrders,
    required this.cancelledOrders,
    required this.note,
  });

  factory WalletDetails.fromJson(Map<String, dynamic> json) {
    return WalletDetails(
      balance: (json['balance'] ?? 0).toDouble(),
      completedOrders: json['completed_orders'] ?? 0,
      refundedOrders: json['refunded_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'completed_orders': completedOrders,
      'refunded_orders': refundedOrders,
      'cancelled_orders': cancelledOrders,
      'note': note,
    };
  }
}
