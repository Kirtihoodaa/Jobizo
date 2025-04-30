import 'package:flutter/material.dart';
import 'package:jobizo/Customer_POV/AppBar/commonAppBar.dart';
import 'package:jobizo/Design%20contraints/FontSizes.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';

class AllottedLaboursScreen extends StatefulWidget {
  const AllottedLaboursScreen({Key? key}) : super(key: key);

  @override
  State<AllottedLaboursScreen> createState() => _AllottedLaboursScreenState();
}

class _AllottedLaboursScreenState extends State<AllottedLaboursScreen> {
  final List<SiteData> sites = [
    SiteData(
      siteName: 'Riverside Tower',
      location: 'Manhattan, NY',
      workersCount: 42,
      workers: [
        Worker(
            name: 'James Wilson', role: 'Plumbing', time: '8:00 AM - 5:00 PM'),
        Worker(
            name: 'Sarah Chen', role: 'Electrical', time: '9:00 AM - 6:00 PM'),
        Worker(
            name: 'Sarah Chen', role: 'Electrical', time: '9:00 AM - 6:00 PM'),
        Worker(
            name: 'Sarah Chen', role: 'Electrical', time: '9:00 AM - 6:00 PM'),
      ],
    ),
    SiteData(
      siteName: 'Central Park Plaza',
      location: 'Brooklyn, NY',
      workersCount: 35,
      workers: [
        Worker(
            name: 'Robert Martinez',
            role: 'Site Foreman',
            time: '7:00 AM - 4:00 PM'),
        Worker(
            name: 'Robert Martinez',
            role: 'Site Foreman',
            time: '7:00 AM - 4:00 PM'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: Commonappbar(title: "Alloted Labour"),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sites.length,
        itemBuilder: (context, index) {
          return SiteCard(site: sites[index]);
        },
      ),
    );
  }
}

class SiteCard extends StatelessWidget {
  final SiteData site;

  const SiteCard({Key? key, required this.site}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                site.siteName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.green,
                    fontSize: secondary()),
              ),
              Spacer(),
              Text('${site.workersCount} Workers',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Text(site.location,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: tertiary(),
                  fontWeight: FontWeight.w400)),
          const SizedBox(height: 8),
          const Divider(),
          ...site.workers.map((w) => WorkerTile(worker: w)).toList(),
        ],
      ),
    );
  }
}

class WorkerTile extends StatelessWidget {
  final Worker worker;

  const WorkerTile({Key? key, required this.worker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: const CircleAvatar(
        backgroundImage: AssetImage('Assets/Labour_image/labour_profile.png'),
        radius: 22,
      ),
      title: Text(worker.name,
          style: TextStyle(
              color: Colors.black,
              fontSize: tertiary(),
              fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(worker.role,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: tertiary(),
                  fontWeight: FontWeight.w400)),
          Text(worker.time,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: tertiary(),
                  fontWeight: FontWeight.w400)),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Active',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class SiteData {
  final String siteName;
  final String location;
  final int workersCount;
  final List<Worker> workers;

  SiteData({
    required this.siteName,
    required this.location,
    required this.workersCount,
    required this.workers,
  });
}

class Worker {
  final String name;
  final String role;
  final String time;

  Worker({
    required this.name,
    required this.role,
    required this.time,
  });
}
