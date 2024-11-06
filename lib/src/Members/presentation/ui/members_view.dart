import 'package:cached_network_image/cached_network_image.dart';
import 'package:ch_db_admin/shared/chached_network_image.dart';
import 'package:ch_db_admin/src/Members/data/models/member_model.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/src/Members/presentation/ui/add_member_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  @override
  void initState() {
    super.initState();
    getMembers();
  }

  void getMembers() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<MemberController>().fetchAllMembers();
      },
    );
  }

  // Sample member data with more features
  final List<MemberModel> members = [
    MemberModel(
      profilePic: 'assets/images/john_doe.jpg',
      fullName: 'John Doe',
      location: 'Accra',
      contact: '0123456789',
      marriageStatus: 'Married',
      spouseName: 'Jane Doe',
      children: ['Child 1', 'Child 2'],
      relativeContact: '0987654321',
      additionalImage: 'assets/images/john_doe_additional.jpg',
      dateOfBirth: DateTime(1990, 1, 1),
    ),
    MemberModel(
      profilePic: 'assets/images/jane_smith.jpg',
      fullName: 'Jane Smith',
      location: 'Tema',
      contact: '0234567890',
      marriageStatus: 'Single',
      spouseName: '',
      children: [],
      relativeContact: '0123456789',
      additionalImage: 'assets/images/jane_smith_additional.jpg',
      dateOfBirth: DateTime(1995, 5, 15),
    ),
    MemberModel(
      profilePic: 'assets/images/michael_johnson.jpg',
      fullName: 'Michael Johnson',
      location: 'Kumasi',
      contact: '0345678901',
      marriageStatus: 'Married',
      spouseName: 'Alice Johnson',
      children: ['Child A'],
      relativeContact: '0234567890',
      additionalImage: 'assets/images/michael_johnson_additional.jpg',
      dateOfBirth: DateTime(1988, 3, 22),
    ),
    MemberModel(
      profilePic: 'assets/images/emily_brown.jpg',
      fullName: 'Emily Brown',
      location: 'Tamale',
      contact: '0456789012',
      marriageStatus: 'Widowed',
      spouseName: 'Late Robert Brown',
      children: ['Child X', 'Child Y', 'Child Z'],
      relativeContact: '0345678901',
      additionalImage: 'assets/images/emily_brown_additional.jpg',
      dateOfBirth: DateTime(1985, 8, 30),
    ),
  ];

  String searchText = '';
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    final membersController = context.watch<MemberController>();

    final theme = Theme.of(context);
    final filteredMembers = membersController.members
        .where((member) =>
            member.fullName.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Members...',
                prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: membersController.isLoading
                  ? Center(
                      child: SpinKitChasingDots(
                        color: theme.primaryColor,
                      ),
                    )
                  : isGridView
                      ? _buildGridView(filteredMembers)
                      : _buildListView(filteredMembers),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMemberView()),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildGridView(List<Member> members) {
    final theme = Theme.of(context);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return GestureDetector(
          onTap: () {
            // Navigate to member details page or perform any action
          },
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  networkImage(member.profilePic!),
                  const SizedBox(height: 10),
                  Text(
                    member.fullName,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<Member> members) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return GestureDetector(
          onTap: () {
            // Navigate to member details page or perform any action
          },
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  networkImage(member.profilePic!),
                    const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.fullName,
                          style: theme.textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          member.location,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
