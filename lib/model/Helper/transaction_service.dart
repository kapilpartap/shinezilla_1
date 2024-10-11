

class TransactionService {
  String? bookingId;
  String? transactionId;
  String? serviceName;
  String? amount;
  String? discountAmount;
  String? payStatus;
  String? bookingStatus;

  TransactionService(
      {this.bookingId,
        this.transactionId,
        this.serviceName,
        this.amount,
        this.discountAmount,
        this.payStatus,
        this.bookingStatus});

  TransactionService.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    transactionId = json['transaction_id'];
    serviceName = json['service_name'];
    amount = json['amount'];
    discountAmount = json['discount_amount'];
    payStatus = json['pay_status'];
    bookingStatus = json['booking_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['transaction_id'] = this.transactionId;
    data['service_name'] = this.serviceName;
    data['amount'] = this.amount;
    data['discount_amount'] = this.discountAmount;
    data['pay_status'] = this.payStatus;
    data['booking_status'] = this.bookingStatus;
    return data;
  }
}
