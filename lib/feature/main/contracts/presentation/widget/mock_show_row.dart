
class MockSchedRow {
  final int number;
  final String date;
  final String method;
  final double due;
  final double paid;
  final double remain;
  final String status; // done | partial | late | upcoming
  const MockSchedRow({
    required this.number,
    required this.date,
    required this.method,
    required this.due,
    required this.paid,
    required this.remain,
    required this.status,
  });
}
class MockContract {
  final int id;
  final String contractNo;
  final String productName;
  final String startDate;
  final double totalAmount;
  final double paidAmount;
  final double remainAmount;
  final double salePrice;
  final double downPayment;
  final double profitRate;
  final String installmentType; // monthly | semi_monthly
  final double installmentAmount;
  final int paidInstallments;
  final int totalInstallments;
  final bool isLate;
  final String status; // active | late | ended
  final List<MockSchedRow> schedule;
  const MockContract({
    required this.id,
    required this.contractNo,
    required this.productName,
    required this.startDate,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainAmount,
    required this.salePrice,
    required this.downPayment,
    required this.profitRate,
    required this.installmentType,
    required this.installmentAmount,
    required this.paidInstallments,
    required this.totalInstallments,
    required this.isLate,
    required this.status,
    this.schedule = const [],
  });
  double get progressPct =>
      totalInstallments == 0 ? 0 : paidInstallments / totalInstallments;
}

const List<MockContract> mockContracts = [
  MockContract(
    id: 1,
    contractNo: '#2025-001',
    productName: 'Samsung Galaxy S25',
    startDate: '1 يناير 2025',
    totalAmount: 7200,
    paidAmount: 2400,
    remainAmount: 4800,
    salePrice: 6800,
    downPayment: 1000,
    profitRate: 6,
    installmentType: 'monthly',
    installmentAmount: 600,
    paidInstallments: 4,
    totalInstallments: 12,
    isLate: false,
    status: 'active',
    schedule: [
      MockSchedRow(
        number: 1,
        date: '1 فبراير',
        method: 'نقدي',
        due: 600,
        paid: 600,
        remain: 0,
        status: 'done',
      ),
      MockSchedRow(
        number: 2,
        date: '1 مارس',
        method: 'مدى',
        due: 600,
        paid: 600,
        remain: 0,
        status: 'done',
      ),
      MockSchedRow(
        number: 3,
        date: '1 أبريل',
        method: 'نقدي',
        due: 600,
        paid: 600,
        remain: 0,
        status: 'done',
      ),
      MockSchedRow(
        number: 4,
        date: '1 مايو',
        method: 'نقدي',
        due: 600,
        paid: 600,
        remain: 0,
        status: 'done',
      ),
      MockSchedRow(
        number: 5,
        date: '1 يونيو',
        method: '—',
        due: 600,
        paid: 0,
        remain: 600,
        status: 'upcoming',
      ),
    ],
  ),
  MockContract(
    id: 2,
    contractNo: '#2024-089',
    productName: 'ثلاجة LG Smart',
    startDate: '5 أغسطس 2024',
    totalAmount: 10800,
    paidAmount: 3150,
    remainAmount: 7650,
    salePrice: 9800,
    downPayment: 1200,
    profitRate: 8,
    installmentType: 'semi_monthly',
    installmentAmount: 450,
    paidInstallments: 7,
    totalInstallments: 24,
    isLate: true,
    status: 'late',
  ),
  MockContract(
    id: 3,
    contractNo: '#2023-045',
    productName: 'Dell XPS 15',
    startDate: '10 مارس 2023',
    totalAmount: 7200,
    paidAmount: 7200,
    remainAmount: 0,
    salePrice: 6600,
    downPayment: 800,
    profitRate: 5,
    installmentType: 'monthly',
    installmentAmount: 600,
    paidInstallments: 12,
    totalInstallments: 12,
    isLate: false,
    status: 'ended',
  ),
];