class FinancialDashboard {
  final String farmerId;
  final String seasonId;
  final double totalInvestment;
  final double expectedRevenue;
  final double actualRevenue;
  final double netProfit;
  final double profitMargin;
  final List<Expense> expenses;
  final List<Sale> sales;
  final List<Loan> loans;
  final List<Claim> claims;
  final DateTime lastUpdated;

  const FinancialDashboard({
    required this.farmerId,
    required this.seasonId,
    required this.totalInvestment,
    required this.expectedRevenue,
    required this.actualRevenue,
    required this.netProfit,
    required this.profitMargin,
    this.expenses = const [],
    this.sales = const [],
    this.loans = const [],
    this.claims = const [],
    required this.lastUpdated,
  });

  factory FinancialDashboard.fromJson(Map<String, dynamic> json) {
    return FinancialDashboard(
      farmerId: json['farmerId'],
      seasonId: json['seasonId'],
      totalInvestment: json['totalInvestment']?.toDouble() ?? 0.0,
      expectedRevenue: json['expectedRevenue']?.toDouble() ?? 0.0,
      actualRevenue: json['actualRevenue']?.toDouble() ?? 0.0,
      netProfit: json['netProfit']?.toDouble() ?? 0.0,
      profitMargin: json['profitMargin']?.toDouble() ?? 0.0,
      expenses: (json['expenses'] as List<dynamic>?)
              ?.map((expense) => Expense.fromJson(expense))
              .toList() ??
          [],
      sales: (json['sales'] as List<dynamic>?)
              ?.map((sale) => Sale.fromJson(sale))
              .toList() ??
          [],
      loans: (json['loans'] as List<dynamic>?)
              ?.map((loan) => Loan.fromJson(loan))
              .toList() ??
          [],
      claims: (json['claims'] as List<dynamic>?)
              ?.map((claim) => Claim.fromJson(claim))
              .toList() ??
          [],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmerId': farmerId,
      'seasonId': seasonId,
      'totalInvestment': totalInvestment,
      'expectedRevenue': expectedRevenue,
      'actualRevenue': actualRevenue,
      'netProfit': netProfit,
      'profitMargin': profitMargin,
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
      'sales': sales.map((sale) => sale.toJson()).toList(),
      'loans': loans.map((loan) => loan.toJson()).toList(),
      'claims': claims.map((claim) => claim.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  double get totalExpenses => expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  double get totalSales => sales.fold(0.0, (sum, sale) => sum + sale.totalAmount);
  double get totalLoans => loans.fold(0.0, (sum, loan) => sum + loan.amount);
  double get totalClaims => claims.fold(0.0, (sum, claim) => sum + claim.amount);
  
  bool get isProfitable => netProfit > 0;
  double get roi => totalInvestment > 0 ? (netProfit / totalInvestment) * 100 : 0.0;
}

class Expense {
  final String id;
  final String farmerId;
  final String? cropId;
  final String? seasonId;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;
  final String notes;
  final String? receiptUrl;

  const Expense({
    required this.id,
    required this.farmerId,
    this.cropId,
    this.seasonId,
    required this.category,
    required this.amount,
    required this.date,
    this.notes = '',
    this.receiptUrl,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      farmerId: json['farmerId'],
      cropId: json['cropId'],
      seasonId: json['seasonId'],
      category: ExpenseCategory.values.firstWhere(
        (category) => category.name == json['category'],
        orElse: () => ExpenseCategory.other,
      ),
      amount: json['amount']?.toDouble() ?? 0.0,
      date: DateTime.parse(json['date']),
      notes: json['notes'] ?? '',
      receiptUrl: json['receiptUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'cropId': cropId,
      'seasonId': seasonId,
      'category': category.name,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
      'receiptUrl': receiptUrl,
    };
  }
}

enum ExpenseCategory {
  seeds,
  fertilizer,
  pesticides,
  labor,
  irrigation,
  machinery,
  fuel,
  transportation,
  storage,
  marketing,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.seeds:
        return 'Seeds';
      case ExpenseCategory.fertilizer:
        return 'Fertilizer';
      case ExpenseCategory.pesticides:
        return 'Pesticides';
      case ExpenseCategory.labor:
        return 'Labor';
      case ExpenseCategory.irrigation:
        return 'Irrigation';
      case ExpenseCategory.machinery:
        return 'Machinery';
      case ExpenseCategory.fuel:
        return 'Fuel';
      case ExpenseCategory.transportation:
        return 'Transportation';
      case ExpenseCategory.storage:
        return 'Storage';
      case ExpenseCategory.marketing:
        return 'Marketing';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  String get iconData {
    switch (this) {
      case ExpenseCategory.seeds:
        return 'eco';
      case ExpenseCategory.fertilizer:
        return 'grass';
      case ExpenseCategory.pesticides:
        return 'pest_control';
      case ExpenseCategory.labor:
        return 'group';
      case ExpenseCategory.irrigation:
        return 'water_drop';
      case ExpenseCategory.machinery:
        return 'precision_manufacturing';
      case ExpenseCategory.fuel:
        return 'local_gas_station';
      case ExpenseCategory.transportation:
        return 'local_shipping';
      case ExpenseCategory.storage:
        return 'warehouse';
      case ExpenseCategory.marketing:
        return 'campaign';
      case ExpenseCategory.other:
        return 'receipt';
    }
  }

  String get colorHex {
    switch (this) {
      case ExpenseCategory.seeds:
        return '#4CAF50';
      case ExpenseCategory.fertilizer:
        return '#8BC34A';
      case ExpenseCategory.pesticides:
        return '#FF9800';
      case ExpenseCategory.labor:
        return '#2196F3';
      case ExpenseCategory.irrigation:
        return '#00BCD4';
      case ExpenseCategory.machinery:
        return '#9E9E9E';
      case ExpenseCategory.fuel:
        return '#F44336';
      case ExpenseCategory.transportation:
        return '#673AB7';
      case ExpenseCategory.storage:
        return '#795548';
      case ExpenseCategory.marketing:
        return '#E91E63';
      case ExpenseCategory.other:
        return '#607D8B';
    }
  }
}

class Sale {
  final String id;
  final String farmerId;
  final String cropId;
  final String? seasonId;
  final double quantity; // in kg or tons
  final double pricePerUnit;
  final double totalAmount;
  final String buyerName;
  final DateTime date;
  final String? invoiceUrl;

  const Sale({
    required this.id,
    required this.farmerId,
    required this.cropId,
    this.seasonId,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalAmount,
    required this.buyerName,
    required this.date,
    this.invoiceUrl,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      farmerId: json['farmerId'],
      cropId: json['cropId'],
      seasonId: json['seasonId'],
      quantity: json['quantity']?.toDouble() ?? 0.0,
      pricePerUnit: json['pricePerUnit']?.toDouble() ?? 0.0,
      totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
      buyerName: json['buyerName'],
      date: DateTime.parse(json['date']),
      invoiceUrl: json['invoiceUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'cropId': cropId,
      'seasonId': seasonId,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
      'totalAmount': totalAmount,
      'buyerName': buyerName,
      'date': date.toIso8601String(),
      'invoiceUrl': invoiceUrl,
    };
  }
}

class Loan {
  final String id;
  final String farmerId;
  final double amount;
  final double interestRate;
  final DateTime disbursedDate;
  final DateTime dueDate;
  final LoanStatus status;
  final String lenderName;
  final double? repaidAmount;
  final DateTime? repaidDate;

  const Loan({
    required this.id,
    required this.farmerId,
    required this.amount,
    required this.interestRate,
    required this.disbursedDate,
    required this.dueDate,
    required this.status,
    required this.lenderName,
    this.repaidAmount,
    this.repaidDate,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      farmerId: json['farmerId'],
      amount: json['amount']?.toDouble() ?? 0.0,
      interestRate: json['interestRate']?.toDouble() ?? 0.0,
      disbursedDate: DateTime.parse(json['disbursedDate']),
      dueDate: DateTime.parse(json['dueDate']),
      status: LoanStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => LoanStatus.active,
      ),
      lenderName: json['lenderName'],
      repaidAmount: json['repaidAmount']?.toDouble(),
      repaidDate: json['repaidDate'] != null 
          ? DateTime.parse(json['repaidDate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'amount': amount,
      'interestRate': interestRate,
      'disbursedDate': disbursedDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'lenderName': lenderName,
      'repaidAmount': repaidAmount,
      'repaidDate': repaidDate?.toIso8601String(),
    };
  }

  double get totalInterest => amount * (interestRate / 100);
  double get totalAmount => amount + totalInterest;
  bool get isOverdue => DateTime.now().isAfter(dueDate) && status != LoanStatus.paid;
  int get daysPastDue => isOverdue ? DateTime.now().difference(dueDate).inDays : 0;
}

enum LoanStatus {
  active,
  paid,
  overdue,
  defaulted,
}

extension LoanStatusExtension on LoanStatus {
  String get displayName {
    switch (this) {
      case LoanStatus.active:
        return 'Active';
      case LoanStatus.paid:
        return 'Paid';
      case LoanStatus.overdue:
        return 'Overdue';
      case LoanStatus.defaulted:
        return 'Defaulted';
    }
  }

  String get colorHex {
    switch (this) {
      case LoanStatus.active:
        return '#2196F3';
      case LoanStatus.paid:
        return '#4CAF50';
      case LoanStatus.overdue:
        return '#FF9800';
      case LoanStatus.defaulted:
        return '#F44336';
    }
  }
}

class Claim {
  final String id;
  final String farmerId;
  final ClaimType type;
  final double amount;
  final ClaimStatus status;
  final DateTime submittedDate;
  final DateTime? approvedDate;
  final DateTime? paidDate;
  final String description;
  final List<String> documentUrls;

  const Claim({
    required this.id,
    required this.farmerId,
    required this.type,
    required this.amount,
    required this.status,
    required this.submittedDate,
    this.approvedDate,
    this.paidDate,
    required this.description,
    this.documentUrls = const [],
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'],
      farmerId: json['farmerId'],
      type: ClaimType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => ClaimType.other,
      ),
      amount: json['amount']?.toDouble() ?? 0.0,
      status: ClaimStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ClaimStatus.pending,
      ),
      submittedDate: DateTime.parse(json['submittedDate']),
      approvedDate: json['approvedDate'] != null 
          ? DateTime.parse(json['approvedDate']) 
          : null,
      paidDate: json['paidDate'] != null 
          ? DateTime.parse(json['paidDate']) 
          : null,
      description: json['description'],
      documentUrls: List<String>.from(json['documentUrls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'type': type.name,
      'amount': amount,
      'status': status.name,
      'submittedDate': submittedDate.toIso8601String(),
      'approvedDate': approvedDate?.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'description': description,
      'documentUrls': documentUrls,
    };
  }
}

enum ClaimType {
  insurance,
  subsidies,
  compensation,
  reimbursement,
  other,
}

enum ClaimStatus {
  pending,
  underReview,
  approved,
  rejected,
  paid,
}

extension ClaimTypeExtension on ClaimType {
  String get displayName {
    switch (this) {
      case ClaimType.insurance:
        return 'Insurance';
      case ClaimType.subsidies:
        return 'Subsidies';
      case ClaimType.compensation:
        return 'Compensation';
      case ClaimType.reimbursement:
        return 'Reimbursement';
      case ClaimType.other:
        return 'Other';
    }
  }
}

extension ClaimStatusExtension on ClaimStatus {
  String get displayName {
    switch (this) {
      case ClaimStatus.pending:
        return 'Pending';
      case ClaimStatus.underReview:
        return 'Under Review';
      case ClaimStatus.approved:
        return 'Approved';
      case ClaimStatus.rejected:
        return 'Rejected';
      case ClaimStatus.paid:
        return 'Paid';
    }
  }

  String get colorHex {
    switch (this) {
      case ClaimStatus.pending:
        return '#FFC107';
      case ClaimStatus.underReview:
        return '#2196F3';
      case ClaimStatus.approved:
        return '#4CAF50';
      case ClaimStatus.rejected:
        return '#F44336';
      case ClaimStatus.paid:
        return '#66BB6A';
    }
  }
}