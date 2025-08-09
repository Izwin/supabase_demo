import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_demo/core/theme/app_theme.dart';
import 'package:supabase_demo/features/coffee/domain/entities/coffee_log.dart';
import 'package:supabase_demo/features/coffee/presentation/bloc/coffee_bloc.dart';
import 'package:supabase_demo/features/coffee/presentation/widgets/add_coffee_dialog.dart';
import 'package:supabase_demo/features/coffee/presentation/widgets/coffee_counter_card.dart';
import 'package:supabase_demo/features/coffee/presentation/widgets/coffee_log_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const String routePath = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<CoffeeBloc>().add(LoadTodayCoffeeLogsEvent());
  }

  void _showAddCoffeeDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCoffeeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Supabase.instance.client.auth.currentUser;
    final String? email = user?.email;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Tracker'),
        elevation: 0,
      ),
      body: BlocConsumer<CoffeeBloc, CoffeeState>(
        listener: (context, state) {
          if (state is CoffeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CoffeeLogAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Coffee added successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CoffeeLoading && state is! CoffeeLogAdded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is TodayCoffeeLoaded) {
            return _buildHomeContent(context, state, email);
          }
          
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<CoffeeBloc>().add(LoadTodayCoffeeLogsEvent());
              },
              child: const Text('Load Data'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCoffeeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, TodayCoffeeLoaded state, String? email) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CoffeeBloc>().add(LoadTodayCoffeeLogsEvent());
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting
          Text(
            'Hello${email != null ? ', ${email.split('@')[0]}' : ''}!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Today is ${DateFormat('EEEE, MMMM d').format(DateTime.now())}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          
          // Coffee counter cards
          Row(
            children: [
              Expanded(
                child: CoffeeCounterCard(
                  title: 'Cups Today',
                  value: state.cupsToday.toString(),
                  icon: Icons.coffee,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CoffeeCounterCard(
                  title: 'Spent Today',
                  value: formatter.format(state.totalSpentToday),
                  icon: Icons.attach_money,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Today's logs
          Text(
            'Today\'s Coffee',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          
          if (state.todayCoffeeLogs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Text(
                  'No coffee logs for today.\nTap the + button to add one!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ..._buildCoffeeLogsList(state.todayCoffeeLogs),
        ],
      ),
    );
  }

  List<Widget> _buildCoffeeLogsList(List<CoffeeLog> logs) {
    return logs.map((log) => CoffeeLogItem(coffeeLog: log)).toList();
  }
} 