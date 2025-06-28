import 'package:ch_db_admin/src/Members/data/repository/member_repo_impl.dart';
import 'package:ch_db_admin/src/Members/domain/repository/member_repo.dart';
import 'package:ch_db_admin/src/Members/presentation/controller/member._controller.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/add_member.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/delete_member.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/get_all_members.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/get_member_by_id.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/get_members_by_name.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/update_member.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:ch_db_admin/src/Members/data/data_source/remote_db.dart';

void initMemberDep() {
  // Data source
  locator.registerLazySingleton<MembersRemoteDb>(() => MembersRemoteDb());

  // Repository
  locator.registerLazySingleton<MemberRepository>(
      () => MemberRepositoryImpl(locator<MembersRemoteDb>()));

  // Use cases
  locator.registerLazySingleton(() => AddMember(locator<MemberRepository>()));
  locator
      .registerLazySingleton(() => GetAllMembers(locator<MemberRepository>()));
  locator
      .registerLazySingleton(() => GetMemberById(locator<MemberRepository>()));
  locator
      .registerLazySingleton(() => UpdateMember(locator<MemberRepository>()));
  locator
      .registerLazySingleton(() => DeleteMember(locator<MemberRepository>()));
  locator.registerLazySingleton(
      () => GetMembersByName(locator<MemberRepository>()));

  // Controller
  locator.registerLazySingleton(() => MemberController(
        locator<AddMember>(),
        locator<GetAllMembers>(),
        locator<GetMemberById>(),
        locator<UpdateMember>(),
        locator<DeleteMember>(),
        locator<GetMembersByName>(),
      ));
}
