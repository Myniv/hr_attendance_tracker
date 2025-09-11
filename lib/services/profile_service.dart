import 'dart:io';
import 'package:hr_attendance_tracker/models/profile.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final CollectionReference profiles = FirebaseFirestore.instance.collection(
    "users",
  );
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createUserProfile(Profile profile) async {
    try {
      await profiles.doc(profile.uid).set(profile.toMap());
    } catch (e) {
      print("Error creating user profile: $e");
      rethrow;
    }
  }

  Future<Profile?> getUserProfile(String uid) async {
    try {
      print("ProfileService: Getting profile for UID: $uid");
      final doc = await profiles.doc(uid).get();
      print("ProfileService: Document exists: ${doc.exists}");

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print("ProfileService: Document data: $data");
        final profile = Profile.fromMap(data);
        print("ProfileService: Profile created: ${profile.uid}");
        return profile;
      }
      print("ProfileService: No document found for UID: $uid");
      return null;
    } catch (e) {
      print("ProfileService: Error getting user profile: $e");
      rethrow;
    }
  }

  Future<List<Profile>> getAllUserProfiles() async {
    try {
      final querySnapshot = await profiles.get();
      return querySnapshot.docs.map((doc) {
        return Profile.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error getting all user profiles: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile(Profile profile) async {
    try {
      await profiles.doc(profile.uid).update(profile.toMap());
    } catch (e) {
      print("Error updating user profile: $e");
      rethrow;
    }
  }

  Future<bool> checkUserExists(String uid) async {
    try {
      final doc = await profiles.doc(uid).get();
      return doc.exists;
    } catch (e) {
      print("Error checking if user exists: $e");
      rethrow;
    }
  }

  Future<String> uploadProfilePhoto(
    String uid,
    File file,
    String oldUrl,
  ) async {
    try {
      final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      final ext = path.extension(file.path);
      final fileName = "${uid}_$timeStamp$ext";

      await deleteOldProfilePhoto(oldUrl);

      await _supabase.storage
          .from('profile_photos')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      final url = _supabase.storage
          .from('profile_photos')
          .getPublicUrl(fileName);

      await profiles.doc(uid).update({'profilePicturePath': url});

      return url;
    } catch (e) {
      print("Error in uploadProfilePhoto: $e");
      rethrow;
    }
  }

  Future<void> deleteOldProfilePhoto(String oldUrl) async {
    try {
      if (oldUrl.isEmpty) return;

      final uri = Uri.parse(oldUrl);
      final pathSegments = uri.pathSegments;

      if (pathSegments.length >= 2) {
        final fileName = pathSegments.last;
        await _supabase.storage.from('profile_photos').remove([fileName]);
        print("Deleted old profile photo: $fileName");
      }
    } catch (e) {
      print("Error deleting old profile photo: $e");
    }
  }
}
