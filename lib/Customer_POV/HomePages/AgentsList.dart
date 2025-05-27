import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobizo/Design%20contraints/app%20color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Design contraints/FontSizes.dart';
import '../../SnackBar/Snackbar.dart';
import '../AppBar/commonAppBar.dart';

/// Model for each agent
class Agent {
  final int id;
  final String agentName;
  final String agencyName;
  final String jobCategory;
  final String contactNumber;
  final String email;
  final String location;

  Agent({
    required this.id,
    required this.agentName,
    required this.agencyName,
    required this.jobCategory,
    required this.contactNumber,
    required this.email,
    required this.location,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] as int,
      agentName: json['agent_name'] as String,
      agencyName: json['agency_name'] as String,
      jobCategory: json['job_category'] as String,
      contactNumber: json['contact_number'] as String,
      email: json['email'] as String,
      location: json['location'] as String,
    );
  }
}

class AgentsList extends StatefulWidget {
  const AgentsList({Key? key}) : super(key: key);

  @override
  State<AgentsList> createState() => _AgentsListState();
}

class _AgentsListState extends State<AgentsList> {
  List<Agent> _agents = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchAgents();
  }

  Future<void> _fetchAgents() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('auth_token') ?? '';
      if (token.isEmpty) {
        SnackbarHelper.showError(context, 'Not authenticated. Please login.');
        return;
      }
      if (!token.startsWith('Bearer ')) token = 'Bearer $token';

      final dio = Dio(BaseOptions(
        headers: {'Authorization': token},
      ));

      final response = await dio.get(
        'https://backend.jobizoindia.com/api/agent',
        options: Options(validateStatus: (s) => s != null && s < 500),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        setState(() {
          _agents = data
              .map((e) => Agent.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      } else {
        _error = 'Failed to load agents (code ${response.statusCode})';
        SnackbarHelper.showError(context, _error);
      }
    } on DioError catch (e) {
      final msg = e.response?.data['message'] ?? e.message;
      _error = 'Network error: $msg';
      SnackbarHelper.showError(context, _error);
    } catch (e) {
      _error = 'Unexpected error: $e';
      SnackbarHelper.showError(context, _error);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildAgentCard(Agent agent) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo placeholder
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  AssetImage('Assets/Customer_Images/List_icon.png'),
            ),

            const SizedBox(width: 16),

            // Agent details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agency name
                  Text(
                    agent.agencyName,
                    style: TextStyle(
                      fontSize: secondary(),
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Agent name & ID
                  Row(
                    children: [
                      const Icon(Icons.person,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Expanded(child: Text(agent.agentName)),
                      Text('ID: ${agent.id}',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Job category & Contact number
                  Row(
                    children: [
                      const Icon(Icons.work, size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Expanded(child: Text(agent.jobCategory)),
                      const SizedBox(width: 16),
                      const Icon(Icons.phone, size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Text(agent.contactNumber),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Text(agent.location),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16, color: AppColors.green),
                      const SizedBox(width: 4),
                      Expanded(child: Text(agent.email)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const Commonappbar(title: 'Agent List'),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.gold))
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Available Agents Card
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.brown,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Available Agents',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    '- ${_agents.length} -',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // List of Agent Cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: _agents
                              .map((agent) => _buildAgentCard(agent))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }
}
