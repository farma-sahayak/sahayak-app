import '../models/crop_detailed.dart';
import '../models/financial_dashboard.dart';

class CropsRepository {
  // Simulate API calls with mock data for now
  
  Future<List<CropDetailed>> getCrops() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    return _getMockCrops();
  }

  Future<FinancialDashboard> getFinancialDashboard(String farmerId, [String? seasonId]) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return _getMockFinancialDashboard(farmerId);
  }

  Future<CropDetailed> addCrop({
    required String name,
    required String emoji,
    required double acres,
    required DateTime plantedDate,
    DateTime? expectedHarvestDate,
    required double totalInvestment,
    required double expectedRevenue,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final newCrop = CropDetailed(
      id: 'crop_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      emoji: emoji,
      acres: acres,
      status: CropStatus.planting,
      healthPercentage: 100,
      plantedDate: plantedDate,
      expectedHarvestDate: expectedHarvestDate,
      totalInvestment: totalInvestment,
      expectedRevenue: expectedRevenue,
      profit: expectedRevenue - totalInvestment,
      profitPercentage: totalInvestment > 0 ? ((expectedRevenue - totalInvestment) / totalInvestment) * 100 : 0,
    );
    
    return newCrop;
  }

  Future<void> updateMilestone(String cropId, String milestoneId, bool isCompleted) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation, this would update the milestone in the backend
  }

  Future<void> addExpense({
    required String farmerId,
    String? cropId,
    required String category,
    required double amount,
    required DateTime date,
    required String notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation, this would add expense to the backend
  }

  Future<void> addSale({
    required String farmerId,
    required String cropId,
    required double quantity,
    required double pricePerUnit,
    required String buyerName,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation, this would add sale to the backend
  }

  Future<String> uploadCropImage(String cropId, String imagePath) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    // In real implementation, this would upload image and return URL
    return 'https://example.com/crop_images/$cropId.jpg';
  }

  // Mock data
  List<CropDetailed> _getMockCrops() {
    return [
      CropDetailed(
        id: 'crop_1',
        name: 'Tomato',
        emoji: '🍅',
        acres: 0.5,
        status: CropStatus.flowering,
        healthPercentage: 85,
        plantedDate: DateTime.now().subtract(const Duration(days: 60)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 30)),
        totalInvestment: 15000,
        expectedRevenue: 35000,
        actualSales: 0,
        profit: 20000,
        profitPercentage: 133.3,
        nextAction: 'Apply fertilizer in 2 days',
        nextActionDate: DateTime.now().add(const Duration(days: 2)),
        milestones: [
          CropMilestone(
            id: 'milestone_1',
            title: 'Watering',
            description: 'Water the tomato plants',
            scheduledDate: DateTime.now().add(const Duration(days: 1)),
            type: MilestoneType.watering,
          ),
          CropMilestone(
            id: 'milestone_2',
            title: 'Fertilizer Application',
            description: 'Apply organic fertilizer',
            scheduledDate: DateTime.now().add(const Duration(days: 2)),
            type: MilestoneType.fertilizing,
          ),
        ],
        issues: [
          CropIssue(
            id: 'issue_1',
            title: 'Leaf curl noticed',
            description: 'Some leaves showing curling symptoms',
            type: IssueType.disease,
            severity: IssueSeverity.medium,
            detectedDate: DateTime.now().subtract(const Duration(days: 2)),
          ),
          CropIssue(
            id: 'issue_2',
            title: 'Some pest activity',
            description: 'Minor pest activity observed',
            type: IssueType.pest,
            severity: IssueSeverity.low,
            detectedDate: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
      ),
      CropDetailed(
        id: 'crop_2',
        name: 'Brinjal',
        emoji: '🍆',
        acres: 0.3,
        status: CropStatus.ready,
        healthPercentage: 95,
        plantedDate: DateTime.now().subtract(const Duration(days: 90)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 3)),
        totalInvestment: 8000,
        expectedRevenue: 18000,
        actualSales: 0,
        profit: 10000,
        profitPercentage: 125.0,
        nextAction: 'Harvest in 3 days',
        nextActionDate: DateTime.now().add(const Duration(days: 3)),
        milestones: [
          CropMilestone(
            id: 'milestone_3',
            title: 'Harvesting',
            description: 'Start harvesting brinjal',
            scheduledDate: DateTime.now().add(const Duration(days: 3)),
            type: MilestoneType.harvesting,
          ),
        ],
        issues: [],
      ),
      CropDetailed(
        id: 'crop_3',
        name: 'Chili',
        emoji: '🌶️',
        acres: 0.2,
        status: CropStatus.growing,
        healthPercentage: 78,
        plantedDate: DateTime.now().subtract(const Duration(days: 45)),
        expectedHarvestDate: DateTime.now().add(const Duration(days: 60)),
        totalInvestment: 5000,
        expectedRevenue: 12000,
        actualSales: 0,
        profit: 7000,
        profitPercentage: 140.0,
        nextAction: 'Watering needed tomorrow',
        nextActionDate: DateTime.now().add(const Duration(days: 1)),
        milestones: [
          CropMilestone(
            id: 'milestone_4',
            title: 'Watering',
            description: 'Regular watering schedule',
            scheduledDate: DateTime.now().add(const Duration(days: 1)),
            type: MilestoneType.watering,
          ),
        ],
        issues: [
          CropIssue(
            id: 'issue_3',
            title: 'Slow growth',
            description: 'Growth rate slower than expected',
            type: IssueType.nutrient,
            severity: IssueSeverity.medium,
            detectedDate: DateTime.now().subtract(const Duration(days: 3)),
          ),
          CropIssue(
            id: 'issue_4',
            title: 'Nutrient deficiency suspected',
            description: 'Possible nitrogen deficiency',
            type: IssueType.nutrient,
            severity: IssueSeverity.high,
            detectedDate: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
      ),
    ];
  }

  FinancialDashboard _getMockFinancialDashboard(String farmerId) {
    return FinancialDashboard(
      farmerId: farmerId,
      seasonId: 'season_2024_rabi',
      totalInvestment: 28000,
      expectedRevenue: 65000,
      actualRevenue: 0,
      netProfit: 37000,
      profitMargin: 132.1,
      lastUpdated: DateTime.now(),
      expenses: [
        Expense(
          id: 'exp_1',
          farmerId: farmerId,
          cropId: 'crop_1',
          category: ExpenseCategory.seeds,
          amount: 2000,
          date: DateTime.now().subtract(const Duration(days: 60)),
          notes: 'Tomato seeds - hybrid variety',
        ),
        Expense(
          id: 'exp_2',
          farmerId: farmerId,
          cropId: 'crop_1',
          category: ExpenseCategory.fertilizer,
          amount: 3000,
          date: DateTime.now().subtract(const Duration(days: 45)),
          notes: 'Organic fertilizer',
        ),
        Expense(
          id: 'exp_3',
          farmerId: farmerId,
          cropId: 'crop_2',
          category: ExpenseCategory.seeds,
          amount: 1500,
          date: DateTime.now().subtract(const Duration(days: 90)),
          notes: 'Brinjal seeds',
        ),
      ],
      sales: [],
      loans: [
        Loan(
          id: 'loan_1',
          farmerId: farmerId,
          amount: 15000,
          interestRate: 8.5,
          disbursedDate: DateTime.now().subtract(const Duration(days: 100)),
          dueDate: DateTime.now().add(const Duration(days: 265)),
          status: LoanStatus.active,
          lenderName: 'Agricultural Bank',
        ),
      ],
      claims: [
        Claim(
          id: 'claim_1',
          farmerId: farmerId,
          type: ClaimType.subsidies,
          amount: 5000,
          status: ClaimStatus.approved,
          submittedDate: DateTime.now().subtract(const Duration(days: 30)),
          approvedDate: DateTime.now().subtract(const Duration(days: 7)),
          description: 'Organic farming subsidy',
        ),
      ],
    );
  }
}