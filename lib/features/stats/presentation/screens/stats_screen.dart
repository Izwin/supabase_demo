import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_demo/core/theme/app_theme.dart';
import 'package:supabase_demo/features/stats/domain/entities/daily_stat.dart';
import 'package:supabase_demo/features/stats/presentation/bloc/stats_bloc.dart';
import 'package:supabase_demo/features/stats/presentation/widgets/stat_card.dart';

class StatsScreen extends StatefulWidget {
  static const String routePath = '/stats';

  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<StatsBloc>().add(LoadWeeklyStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        elevation: 0,
      ),
      body: BlocConsumer<StatsBloc, StatsState>(
        listener: (context, state) {
          if (state is StatsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is StatsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is StatsLoaded) {
            return _buildStatsContent(context, state);
          }
          
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<StatsBloc>().add(LoadWeeklyStatsEvent());
              },
              child: const Text('Load Statistics'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsContent(BuildContext context, StatsLoaded state) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StatsBloc>().add(LoadWeeklyStatsEvent());
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Weekly summary cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Weekly Cups',
                  value: state.weeklyStats.totalCups.toString(),
                  icon: Icons.coffee,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  title: 'Weekly Spent',
                  value: currencyFormatter.format(state.weeklyStats.totalSpent),
                  icon: Icons.attach_money,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Charts
          Text(
            'Cups per Day',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildCupsChart(state.weeklyStats.dailyStats),
          ),
          const SizedBox(height: 32),
          
          Text(
            'Money Spent per Day',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: _buildSpentChart(state.weeklyStats.dailyStats),
          ),
        ],
      ),
    );
  }

  Widget _buildCupsChart(List<DailyStat> dailyStats) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxCups(dailyStats) + 1,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toInt()} cups',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dailyStats.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('E').format(dailyStats[index].date),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return const Text('');
                }
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: dailyStats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: stat.cups.toDouble(),
                color: AppTheme.primaryColor,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpentChart(List<DailyStat> dailyStats) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxSpent(dailyStats) + 5,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.grey.shade800,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
              return BarTooltipItem(
                currencyFormatter.format(rod.toY),
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dailyStats.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('E').format(dailyStats[index].date),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) {
                  return const Text('');
                }
                final currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
                return Text(
                  currencyFormatter.format(value),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 50,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: dailyStats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: stat.spent,
                color: AppTheme.secondaryColor,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  double _getMaxCups(List<DailyStat> dailyStats) {
    if (dailyStats.isEmpty) return 5;
    return dailyStats.map((stat) => stat.cups.toDouble()).reduce((a, b) => a > b ? a : b);
  }

  double _getMaxSpent(List<DailyStat> dailyStats) {
    if (dailyStats.isEmpty) return 20;
    return dailyStats.map((stat) => stat.spent).reduce((a, b) => a > b ? a : b);
  }
} 