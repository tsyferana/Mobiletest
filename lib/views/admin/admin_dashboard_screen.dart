import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  static const routeName = '/admin/dashboard';

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // Mock admin stats
  final int _totalUsers = 1_245;
  final int _totalBusinesses = 328;
  final int _totalReviews = 5_847;
  final int _pendingReports = 12;
  final int _pendingApprovals = 18;

  // Mock users growth data (30 days)
  late List<int> _usersGrowthData;
  late List<String> _growthLabels;

  // Mock business by category
  final Map<String, int> _businessByCategory = {
    'Restaurants': 95,
    'Hôtels': 52,
    'Boutiques': 68,
    'Services': 73,
    'Autres': 40,
  };

  // Mock recent activity
  late List<_ActivityItem> _recentActivity;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    // Users growth (last 30 days)
    _growthLabels = ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4'];
    _usersGrowthData = [285, 320, 298, 342];

    // Recent activity
    _recentActivity = [
      _ActivityItem(
        type: 'user',
        title: 'Nouvel utilisateur',
        subtitle: 'Aina Rajaonarivelo',
        icon: Icons.person_add_rounded,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      _ActivityItem(
        type: 'report',
        title: 'Signalement reçu',
        subtitle: 'Avis problématique - Toile Café',
        icon: Icons.flag_rounded,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      _ActivityItem(
        type: 'review',
        title: 'Nouvel avis',
        subtitle: 'La Varangue - 5 étoiles',
        icon: Icons.rate_review_rounded,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      _ActivityItem(
        type: 'user',
        title: 'Nouvel utilisateur',
        subtitle: 'Rakoto Jean',
        icon: Icons.person_add_rounded,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      _ActivityItem(
        type: 'business',
        title: 'Entreprise en attente',
        subtitle: 'New Business Hub - Attente approbation',
        icon: Icons.business_rounded,
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      _ActivityItem(
        type: 'review',
        title: 'Nouvel avis',
        subtitle: 'Toile Café - 4 étoiles',
        icon: Icons.rate_review_rounded,
        timestamp: DateTime.now().subtract(const Duration(hours: 18)),
      ),
    ];
  }

  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            // Sidebar
            SizedBox(width: 280, child: _buildAdminSidebar(context)),
            // Main content
            Expanded(child: _buildMainContent(context)),
          ],
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        drawer: _buildAdminDrawer(context),
        body: _buildMainContent(context),
      );
    }
  }

  Widget _buildAdminSidebar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final menuItems = [
      ('Dashboard', Icons.dashboard_rounded, '/admin/dashboard'),
      ('Utilisateurs', Icons.people_rounded, '/admin/users'),
      ('Entreprises', Icons.business_rounded, '/admin/businesses'),
      ('Avis', Icons.rate_review_rounded, '/admin/reviews'),
      ('Signalements', Icons.flag_rounded, '/admin/reports'),
      ('Paramètres', Icons.settings_rounded, '/admin/settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'ReviewApp',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...menuItems.map((item) {
                final (label, icon, route) = item;
                final isActive = ModalRoute.of(context)?.settings.name == route;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: NavigationDrawerDestination(
                    label: Text(label),
                    icon: Icon(icon),
                    selected: isActive,
                    onTap: () {
                      context.go(route);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDrawer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final menuItems = [
      ('Dashboard', Icons.dashboard_rounded, '/admin/dashboard'),
      ('Utilisateurs', Icons.people_rounded, '/admin/users'),
      ('Entreprises', Icons.business_rounded, '/admin/businesses'),
      ('Avis', Icons.rate_review_rounded, '/admin/reviews'),
      ('Signalements', Icons.flag_rounded, '/admin/reports'),
      ('Paramètres', Icons.settings_rounded, '/admin/settings'),
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.admin_panel_settings_rounded,
                  size: 32,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(height: 8),
                Text(
                  'Admin',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  'ReviewApp',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          ...menuItems.map((item) {
            final (label, icon, route) = item;
            final isActive = ModalRoute.of(context)?.settings.name == route;

            return ListTile(
              leading: Icon(icon),
              title: Text(label),
              selected: isActive,
              onTap: () {
                Navigator.pop(context);
                context.go(route);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat cards grid
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width >= 900 ? 5 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _StatCard(
                label: 'Utilisateurs',
                value: '$_totalUsers',
                icon: Icons.people_rounded,
                color: Colors.blue,
              ),
              _StatCard(
                label: 'Entreprises',
                value: '$_totalBusinesses',
                icon: Icons.business_rounded,
                color: Colors.purple,
              ),
              _StatCard(
                label: 'Avis totaux',
                value: '$_totalReviews',
                icon: Icons.rate_review_rounded,
                color: Colors.orange,
              ),
              _StatCard(
                label: 'Signalements',
                value: '$_pendingReports',
                icon: Icons.flag_rounded,
                color: Colors.red,
                highlight: _pendingReports > 0,
              ),
              _StatCard(
                label: 'En attente',
                value: '$_pendingApprovals',
                icon: Icons.hourglass_bottom_rounded,
                color: Colors.amber,
                highlight: _pendingApprovals > 0,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Charts section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Croissance des utilisateurs',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          height: 200,
                          child: _LineChartWidget(
                            data: _usersGrowthData,
                            labels: _growthLabels,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entreprises par catégorie',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          height: 200,
                          child: _CategoryBarsWidget(data: _businessByCategory),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent activity and quick access
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRecentActivity(context)),
              const SizedBox(width: 12),
              Expanded(child: _buildQuickAccess(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activité récente',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentActivity.length,
            separatorBuilder: (_, __) =>
                Divider(color: colorScheme.outlineVariant),
            itemBuilder: (context, index) {
              final activity = _recentActivity[index];
              final timeAgo = _getTimeAgo(activity.timestamp);

              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getActivityColor(
                          activity.type,
                        ).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        activity.icon,
                        size: 18,
                        color: _getActivityColor(activity.type),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activity.subtitle,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeAgo,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final quickAccessItems = [
      ('Modérer', Icons.done_all_rounded, '/admin/reports', Colors.blue),
      (
        'Approuver',
        Icons.check_circle_rounded,
        '/admin/businesses',
        Colors.green,
      ),
      ('Bloquer', Icons.block_rounded, '/admin/users', Colors.red),
      ('Paramètres', Icons.settings_rounded, '/admin/settings', Colors.grey),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accès rapide',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        ...quickAccessItems.map((item) {
          final (label, icon, route, color) = item;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              child: InkWell(
                onTap: () => context.go(route),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: color, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 260.ms).slideX(begin: 0.04),
          );
        }),
      ],
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'user':
        return Colors.blue;
      case 'business':
        return Colors.purple;
      case 'review':
        return Colors.orange;
      case 'report':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'il y a ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'il y a ${difference.inDays}j';
    } else {
      return DateFormat('d MMM', 'fr_FR').format(timestamp);
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: highlight
              ? color.withOpacity(0.5)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                if (highlight)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Action',
                      style: textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04);
  }
}

class _LineChartWidget extends StatelessWidget {
  const _LineChartWidget({
    required this.data,
    required this.labels,
    required this.color,
  });

  final List<int> data;
  final List<String> labels;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(
        data: data,
        labels: labels,
        color: color,
        textTheme: Theme.of(context).textTheme,
        colorScheme: Theme.of(context).colorScheme,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.data,
    required this.labels,
    required this.color,
    required this.textTheme,
    required this.colorScheme,
  });

  final List<int> data;
  final List<String> labels;
  final Color color;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();
    final minValue = 0.0;
    final padding = 40.0;
    final chartWidth = size.width - (padding * 2);
    final chartHeight = size.height - (padding * 2);

    // Draw grid lines and labels
    final paint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 1;

    // Draw X-axis
    canvas.drawLine(
      Offset(padding, size.height - padding),
      Offset(size.width - padding, size.height - padding),
      paint,
    );

    // Draw data points and lines
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()..color = color;

    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = padding + (i / (data.length - 1)) * chartWidth;
      final y =
          size.height -
          padding -
          ((data[i] - minValue) / (maxValue - minValue)) * chartHeight;
      points.add(Offset(x, y));
    }

    // Draw line
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    // Draw dots
    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(
        point,
        4,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2,
      );
    }

    // Draw labels
    for (int i = 0; i < labels.length; i++) {
      final x = padding + (i / (labels.length - 1)) * chartWidth;
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        Offset(x - textPainter.width / 2, size.height - padding + 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CategoryBarsWidget extends StatelessWidget {
  const _CategoryBarsWidget({required this.data});

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CategoryBarsPainter(
        data: data,
        textTheme: Theme.of(context).textTheme,
        colorScheme: Theme.of(context).colorScheme,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _CategoryBarsPainter extends CustomPainter {
  _CategoryBarsPainter({
    required this.data,
    required this.textTheme,
    required this.colorScheme,
  });

  final Map<String, int> data;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  static const List<Color> _colors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFE66D),
    Color(0xFF95E1D3),
    Color(0xFFC7CEEA),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.values.reduce((a, b) => a > b ? a : b).toDouble();
    final padding = 10.0;
    final barSpacing = (size.width - (padding * 2)) / data.length;
    final chartHeight = size.height - 30;

    int index = 0;
    data.forEach((label, value) {
      final barX = padding + (index * barSpacing) + barSpacing * 0.15;
      final barWidth = barSpacing * 0.7;
      final barHeight = (value / maxValue) * chartHeight;
      final barY = size.height - barHeight - 20;

      // Draw bar
      final barPaint = Paint()..color = _colors[index % _colors.length];
      canvas.drawRRect(
        RRect.fromLTRBR(
          barX,
          barY,
          barX + barWidth,
          size.height - 20,
          const Radius.circular(4),
        ),
        barPaint,
      );

      // Draw value on top
      final valuePainter = TextPainter(
        text: TextSpan(
          text: value.toString(),
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();
      valuePainter.paint(
        Offset(barX + (barWidth - valuePainter.width) / 2, barY - 16),
      );

      // Draw label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(
        Offset(barX + (barWidth - labelPainter.width) / 2, size.height - 16),
      );

      index++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActivityItem {
  _ActivityItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.timestamp,
  });

  final String type;
  final String title;
  final String subtitle;
  final IconData icon;
  final DateTime timestamp;
}
