class ModelTransactionsHistory {
  String? status;
  String? totalRecords;
  String? page;
  String? limit;
  dynamic totalAmount;
  Transaction? lastTransaction;
  List<Transaction>? transactions;

  ModelTransactionsHistory({
    this.status,
    this.totalRecords,
    this.page,
    this.limit,
    this.totalAmount,
    this.lastTransaction,
    this.transactions,
  });

  ModelTransactionsHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalRecords = json['total_records'];
    page = json['page'];
    limit = json['limit'];
    totalAmount = json['total_amount'];
    try {
      lastTransaction = json['last_transaction'] != null
          ? Transaction.fromJson(json['last_transaction'])
          : null;
    } catch (e) {
      // TODO
    }
    transactions = <Transaction>[];
    if (json['transactions'] != null && json['transactions'] != false) {
      json['transactions'].forEach((v) {
        transactions!.add(Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_records'] = totalRecords;
    data['page'] = page;
    data['limit'] = limit;
    data['total_amount'] = totalAmount;
    if (lastTransaction != null) {
      data['last_transaction'] = lastTransaction!.toJson();
    }
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
  String? id;
  String? pAmount;
  String? pMode;
  String? pType;
  String? status;
  String? description;
  String? firstname;
  String? lastname;
  String? date;

  Transaction({
    this.id,
    this.pAmount,
    this.pMode,
    this.pType,
    this.status,
    this.description,
    this.firstname,
    this.lastname,
    this.date,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pAmount = json['p_amount'];
    pMode = json['p_mode'];
    pType = json['p_type'];
    status = json['status'];
    description = json['description'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['p_amount'] = pAmount;
    data['p_mode'] = pMode;
    data['p_type'] = pType;
    data['status'] = status;
    data['description'] = description;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['date'] = date;
    return data;
  }
}
