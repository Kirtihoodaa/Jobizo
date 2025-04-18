import 'package:flutter/material.dart';
import 'package:jobizo/Design contraints/app color.dart';
import 'package:jobizo/Design contraints/FontSizes.dart';

// import '../../app_bar.dart';
import '../../All_app_bars/app_bar.dart';
import '../NavBar.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({Key? key}) : super(key: key);

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  int _selectedFilter = 0;

  final List<Map<String, String>> _filters = [
    {'label': 'All',     'count': '24'},
    {'label': 'Pending', 'count': '8'},
    {'label': 'Approved','count': '12'},
    {'label': 'Rejected','count': '12'},
  ];

  final List<Map<String, String>> _apps = [
    {
      'name':       'Sarah Martinez',
      'role':       'Electrician',
      'company':    'RAA Construction Co.',
      'location':   'Boston, MA',
      'startDate':  '15-04-2025',
      'duration':   '3 Months',
      'status':     'Pending',
    },
    {
      'name':       'Sarah Martinez',
      'role':       'Electrician',
      'company':    'VIP Construction Co.',
      'location':   'Boston, MA',
      'startDate':  '15-04-2025',
      'duration':   '3 Months',
      'status':     'Accepted',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        name: 'Deepak',
        location: 'Chandigarh',
        profileImageUrl: '',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Search Bar ───────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: AppColors.gold),
                  hintText: 'Search applications…',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: secondary(),
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ─── Filter Tabs ──────────────────────────
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final isSel = i == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.gold : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.gold,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${f['label']} ${f['count']}',
                        style: TextStyle(
                          fontSize: tertiary(),
                          color: isSel ? Colors.white : AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ─── Application Cards ────────────────────
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _apps.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, idx) {
                final a = _apps[idx];
                final status = a['status']!;
                final statusColor = status == 'Pending'
                    ? AppColors.gold
                    : status == 'Accepted'
                    ? Colors.lightGreen[700]
                    : Colors.brown;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // header: avatar, name/role, status badge
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage('assets/avatar.png'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a['name']!,
                                  style: TextStyle(
                                    fontSize: secondary(),
                                    fontWeight: FontWeight.w600,
                                    color:AppColors.green
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  a['role']!,
                                  style: TextStyle(
                                    fontSize: tertiary(),
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: tertiary(),
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // company name
                      Text(
                        a['company']!,
                        style: TextStyle(
                          fontSize: secondary(),
                          fontWeight: FontWeight.w600,
                          color:AppColors.green
                        ),
                      ),

                      const SizedBox(height: 8),

                      // location + start date
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            a['location']!,
                            style: TextStyle(fontSize: tertiary()),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.schedule, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'Start Date: ${a['startDate']}',
                            style: TextStyle(fontSize: tertiary()),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // duration
                      Row(
                        children: [
                          Icon(Icons.hourglass_bottom, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            a['duration']!,
                            style: TextStyle(fontSize: tertiary()),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // View Details button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // TODO: navigate to detail page
                          },
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: tertiary(),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBarLabour(currentIndex: 1),
    );
  }
}
