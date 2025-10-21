/// Dashboard Model for dashboard data and analytics
class DashboardModel {
  final double? totalEarning;
  final double? totalRating;
  final List<double>? orderCountsListForChart;
  final List<double>? rentalCountsListForChart;
  final List<String>? productTitlesListForChart;
  final Map<String, dynamic>? rawData;

  DashboardModel({
    this.totalEarning,
    this.totalRating,
    this.orderCountsListForChart,
    this.rentalCountsListForChart,
    this.productTitlesListForChart,
    this.rawData,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    List<double> parseDoubleList(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data.map((e) {
          if (e is double) return e;
          if (e is int) return e.toDouble();
          if (e is String) return double.tryParse(e) ?? 0.0;
          return 0.0;
        }).toList();
      }
      return [];
    }

    List<String> parseStringList(dynamic data) {
      if (data == null) return [];
      if (data is List) {
        return data.map((e) => e?.toString() ?? '').toList();
      }
      return [];
    }

    return DashboardModel(
      totalEarning: json['totalEarning'] != null
          ? double.tryParse(json['totalEarning'].toString())
          : null,
      totalRating: json['totalRating'] != null
          ? double.tryParse(json['totalRating'].toString())
          : null,
      orderCountsListForChart: parseDoubleList(json['orderCountsListForChart']),
      rentalCountsListForChart: parseDoubleList(
        json['rentalCountsListForChart'],
      ),
      productTitlesListForChart: parseStringList(
        json['productTitelsListForChart'],
      ),
      rawData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEarning': totalEarning,
      'totalRating': totalRating,
      'orderCountsListForChart': orderCountsListForChart,
      'rentalCountsListForChart': rentalCountsListForChart,
      'productTitelsListForChart': productTitlesListForChart,
      ...?rawData,
    };
  }

  /// Get formatted total earning
  String get formattedTotalEarning {
    if (totalEarning == null) return '\$0.00';
    return '\$${totalEarning!.toStringAsFixed(2)}';
  }

  /// Get formatted total rating
  String get formattedTotalRating {
    if (totalRating == null) return '0.0';
    return totalRating!.toStringAsFixed(1);
  }

  /// Check if chart data is available
  bool get hasChartData {
    return (orderCountsListForChart?.isNotEmpty ?? false) ||
        (rentalCountsListForChart?.isNotEmpty ?? false);
  }

  /// Get maximum value for chart scaling
  double get maxChartValue {
    if (!hasChartData) return 3.0;

    double maxOrder =
        orderCountsListForChart?.reduce((a, b) => a > b ? a : b) ?? 0.0;
    double maxRental =
        rentalCountsListForChart?.reduce((a, b) => a > b ? a : b) ?? 0.0;

    double maxValue = maxOrder > maxRental ? maxOrder : maxRental;
    return maxValue + 0.5; // Add buffer
  }

  /// Get chart data length
  int get chartDataLength {
    return productTitlesListForChart?.length ?? 0;
  }

  /// Check if dashboard has data
  bool get hasData {
    return totalEarning != null || totalRating != null || hasChartData;
  }

  @override
  String toString() {
    return 'DashboardModel(totalEarning: $totalEarning, totalRating: $totalRating, chartDataLength: $chartDataLength)';
  }
}
