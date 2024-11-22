// lib/src/Members/presentation/controllers/member_controller.dart

import 'package:ch_db_admin/src/Members/domain/usecases/add_member.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/delete_member.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/get_all_members.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/get_member_by_id.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/get_members_by_name.dart';
import 'package:ch_db_admin/src/Members/domain/usecases/update_member.dart';
import 'package:flutter/foundation.dart';
import 'package:ch_db_admin/src/Members/domain/entities/member.dart';
import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';

class MemberController extends ChangeNotifier {
  // Injected use cases
  final AddMember _addMember;
  final GetAllMembers _getAllMembers;
  final GetMemberById _getMemberById;
  final UpdateMember _updateMember;
  final DeleteMember _deleteMember;
  final GetMembersByName _getMembersByName;

  MemberController(
    this._addMember,
    this._getAllMembers,
    this._getMemberById,
    this._updateMember,
    this._deleteMember,
    this._getMembersByName,
  );

  // State properties
  List<Member> _members = [];
  Member? _selectedMember;
  String _statusMessage = '';
  bool _isLoading = false;

  List<Member> get members => _members;
  Member? get selectedMember => _selectedMember;
  String get statusMessage => _statusMessage;
  bool get isLoading => _isLoading;

  // Fetch all members
  Future<void> fetchAllMembers() async {
    setLoading(true);
    final result = await _getAllMembers(NoParams());

    result.fold(
      (failure) => _handleFailure(failure),
      (fetchedMembers) {
        _members = fetchedMembers;
        _statusMessage = 'Members fetched successfully';
      },
    );

    setLoading(false);
  }

  // Add a new member
  Future<void> addMember(Member member) async {
    setLoading(true);
    final result = await _addMember(Params(member));
    print(member.groupAffiliate);
    result.fold(
      (failure) => _handleFailure(failure),
      (successMessage) {
        _clearError();
        _statusMessage = successMessage;
        print(_statusMessage);

        notifyListeners();
        fetchAllMembers(); // Refresh list after adding
      },
    );

    setLoading(false);
  }

  // Get a specific member by ID
  Future<void> getMemberById(String memberId) async {
    setLoading(true);
    final result = await _getMemberById(Params(memberId));

    result.fold(
      (failure) => _handleFailure(failure),
      (member) {
        _clearError();
        _selectedMember = member;
        _statusMessage = 'Member fetched successfully';
        notifyListeners();
      },
    );

    setLoading(false);
  }

  // Update an existing member by ID
  Future<void> updateMember(String memberId, Member member) async {
    setLoading(true);
    final result = await _updateMember(Params(memberId, data2: member));

    result.fold(
      (failure) => _handleFailure(failure),
      (successMessage) {
        _clearError();
        _statusMessage = successMessage;
        notifyListeners();
        fetchAllMembers(); // Refresh list after updating
      },
    );

    setLoading(false);
  }

  // Delete a member by ID
  Future<void> deleteMember(String memberId) async {
    setLoading(true);
    final result = await _deleteMember(Params(memberId));

    result.fold(
      (failure) => _handleFailure(failure),
      (successMessage) {
        _clearError();
        _statusMessage = successMessage;
        fetchAllMembers(); // Refresh list after deleting
      },
    );

    setLoading(false);
  }

  // Get members by name (or partial match)
  Future<void> searchMembersByName(String name) async {
    setLoading(true);
    final result = await _getMembersByName(Params(name));

    result.fold(
      (failure) => _handleFailure(failure),
      (matchingMembers) {
        _clearError();
        _members = matchingMembers;
        _statusMessage = 'Members matching "$name" fetched successfully';
      },
    );

    setLoading(false);
  }

  // Helper functions to handle state changes
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _handleFailure(Failure failure) {
    _statusMessage = 'Error: ${failure.message}';
    notifyListeners();
  }

  void _clearError() {
    _statusMessage = '';
    notifyListeners();
  }
}
