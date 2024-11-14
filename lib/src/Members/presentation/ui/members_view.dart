import 'package:cached_network_image/cached_network_image.dart';
import 'package:ch_db_admin/shared/chached_network_image.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/src/Members/presentation/ui/add_member_view.dart';
import 'package:ch_db_admin/src/Members/presentation/ui/member_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView>
    with AutomaticKeepAliveClientMixin {
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

  void debugImageCache() {
    final cache = PaintingBinding.instance.imageCache;
    print('Current cache size: ${cache.currentSizeBytes} bytes');
    print('Cache currentSize count: ${cache.currentSize}');
    print('Cache liveImageCount count: ${cache.liveImageCount}');
  }

  String searchText = '';
  bool isGridView = false;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //from automatic keep alive
    super.build(context);
    final membersController = context.watch<MemberController>();

    final theme = Theme.of(context);
    final members = membersController.members;
    final filteredMembers = members
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
                  : membersController.members.isEmpty
                      ? const Center(
                          child: Text('No member added yet'),
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

  Widget _buildListView(List<Member> members) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        debugImageCache();

        final member = members[index];
        return Card(
          key: ValueKey(index),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            leading: networkImage(member.profilePic!),
            title: Text(
              member.fullName,
              style: theme.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              member.role == 'None' ? '' : member.role!,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MemberInfoWidget(member: member),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddMemberView(member: member),
                      ),
                    );
                  },
                  child: const Text("Edit"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<Member> members) {
    final theme = Theme.of(context);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 160),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return GestureDetector(
          key: ValueKey(index),
          onTap: () {
            //modal bottom sheet to display more details of a member
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: networkImage(member.profilePic!),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          member.fullName,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 10),
                      MemberInfoWidget(member: member),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddMemberView(member: member),
                              ),
                            );
                          },
                          child: const Text("Edit"),
                        ),
                      ),
                    ],
                  )),
            );
          },
          child: Stack(
            children: [
              Card(
                elevation: 3,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              member.additionalImage!),
                          fit: BoxFit.cover)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        member.fullName,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
