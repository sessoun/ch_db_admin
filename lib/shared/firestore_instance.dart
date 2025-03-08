import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

///return a firestore collection [collection('organisations')]
CollectionReference<Map<String, dynamic>> firestoreCollection() =>
    FirebaseFirestore.instance
        .collection(kReleaseMode ? 'organisations' : 'test_org');
