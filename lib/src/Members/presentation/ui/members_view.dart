import 'package:cached_network_image/cached_network_image.dart';
import 'package:ch_db_admin/shared/chached_network_image.dart';
import 'package:ch_db_admin/shared/utils/create_google_form.dart';
import 'package:ch_db_admin/shared/utils/extensions.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/src/Members/presentation/ui/add_member_view.dart';
import 'package:ch_db_admin/src/Members/presentation/ui/member_info_widget.dart';
import 'package:ch_db_admin/src/Members/presentation/ui/member_status_indicator.dart';
import 'package:ch_db_admin/src/Members/presentation/ui/pick_process_xlsx.dart';
import 'package:ch_db_admin/src/auth/presentation/ui/orgname_dialog.dart';
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
        await checkOnOrgName(context);

        await context.read<MemberController>().fetchAllMembers();
      },
    );
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
          // onPressed: () {
          //   // Directly navigate to AddMemberView for now
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const AddMemberView(),
          //     ),
          //   );
          // },
          child: const Icon(Icons.person_add),
          // ),

          // --- Commented out dialog for adding member ---
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Add Member"),
                content: const Text("How would you like to add a member?"),
                actionsAlignment: MainAxisAlignment.start,
                actionsOverflowAlignment: OverflowBarAlignment.start,
                actions: [
                  // ✅ Fill Form Manually
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddMemberView()),
                      );
                    },
                    child: const Text("1. Fill Form Manually"),
                  ),

                  // ✅ Upload Excel File
                  TextButton(
                    onPressed: () async {
                      await pickAndProcessExcel(
                          context); // Call function to handle Excel upload
                      Navigator.pop(context); // Close dialog
                    },
                    child: const Text(
                        "2. Upload Excel File\n(First generate form if you haven't. Select 'Share Google Form Link' below)"),
                  ).loadingIndicator(
                      context, context.watch<MemberController>().isLoading),

                  // ✅ Share Google Form
                  TextButton(
                    onPressed: () async {
                      membersController.setCreatingGoogleForm(true);
                      var formLink = await generateAndShareGoogleForm(context);
                      membersController.setCreatingGoogleForm(false);

                      if (context.mounted){
                        Navigator.pop(context);} // Close dialog
                      if (!formLink!.contains('null')) {
                        if (context.mounted) {
                          showFormBottomSheet(context, formLink);
                        }
                      }
                    },
                    child: const Text("3. Share Google Form Link"),
                  ).loadingIndicator(context,
                      context.watch<MemberController>().isCreatingGoogleForm),
                ],
              ),
            );
          },
        ));
  }

  Widget _buildListView(List<Member> members) {
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
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
              leading: member.profilePic != null
                  ? SizedBox(
                      height: 48,
                      width: 48,
                      child: Center(
                        child: networkImage(member.profilePic!),
                      ),
                    )
                  : Image.asset(
                      'images/img.png',
                      height: 30,
                      width: 30,
                    ),
              title: Text(
                member.fullName,
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                member.role == 'None' ? '' : member.role!,
              ),
              trailing: memberStatusIndicator(member.status),
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
              ]),
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
              useSafeArea: true,
              isScrollControlled: true,
              isDismissible: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: member.profilePic != null
                                ? networkImage(member.profilePic!, radius: 40)
                                : Image.asset('images/img.png',
                                    height: 40, width: 40)),
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
                              Navigator.of(context).pop();
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
                    ),
                  )),
            );
          },
          child: Stack(
            children: [
              Card(
                elevation: 3,
                child: Container(
                  decoration: member.profilePic != null ||
                          member.additionalImage != null
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  member.additionalImage == null ||
                                          member.additionalImage!.isEmpty
                                      ? member.profilePic!
                                      : member.additionalImage!),
                              fit: BoxFit.cover))
                      : null,
                  child: member.profilePic == null &&
                          member.additionalImage == null
                      ? Center(
                          child: Image.asset(
                          'images/img.png',
                        ))
                      : null,
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
              Positioned(
                top: 8,
                right: 8,
                child: memberStatusIndicator(member.status),
              ),
            ],
          ),
        );
      },
    );
  }
}
