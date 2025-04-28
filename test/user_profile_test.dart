import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastesortapp/frontend/service/user_service.dart';

void main() {
  late UserService userService;
  late FakeFirebaseFirestore mockFirestore;

  setUp(() {
    mockFirestore = FakeFirebaseFirestore();
    userService = UserService.test(firestore: mockFirestore);
  });

  group('Profile Management', () {
    test('updates Username', () async {
      const userId = 'testUserId';
      const name = 'New Name';

      // Insert user data ban đầu
      await mockFirestore.collection('users').doc(userId).set({
        'name': 'Old Name',
      });

      // Gọi updateUserProfile
      await userService.updateUserProfile(userId, name: name);

      // Lấy lại dữ liệu sau khi update
      final snapshot = await mockFirestore.collection('users').doc(userId).get();
      final data = snapshot.data();

      // Kiểm tra dữ liệu đã được cập nhật chưa
      expect(data?['name'], equals(name));
    });

    test('updates Date of Birth', () async {
      const userId = 'testUserId';
      const dob = '01/01/2000'; // Định dạng dd/MM/yyyy

      // Insert user data ban đầu
      await mockFirestore.collection('users').doc(userId).set({
        'dob': '01/01/1990',
      });

      // Gọi updateUserProfile
      await userService.updateUserProfile(
        userId,
        dob: DateFormat('dd/MM/yyyy').parse(dob),
      );

      // Lấy lại dữ liệu sau khi update
      final snapshot = await mockFirestore.collection('users').doc(userId).get();
      final data = snapshot.data();

      // Kiểm tra dữ liệu đã được cập nhật chưa
      expect(data?['dob'], equals(dob));
    });

    test('updates Country', () async {
      const userId = 'testUserId';
      const country = 'Vietnam';

      // Insert user data ban đầu
      await mockFirestore.collection('users').doc(userId).set({
        'country': 'Old Country',
      });

      // Gọi updateUserProfile
      await userService.updateUserProfile(userId, country: country);

      // Lấy lại dữ liệu sau khi update
      final snapshot = await mockFirestore.collection('users').doc(userId).get();
      final data = snapshot.data();

      // Kiểm tra dữ liệu đã được cập nhật chưa
      expect(data?['country'], equals(country));
    });
  });
}
