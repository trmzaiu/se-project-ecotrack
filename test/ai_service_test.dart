import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:wastesortapp/scanAI/processImage.dart';

void main() {
  group('Upload Trash Images & Integrate AI Classification', () {
    group('Successfully Cases', () {
      test('returns Recyclable when prediction is Paper', () async {
      final file = File('test/assets/newspaper.jpg');

      final result = await ApiService.classifyImage(file);
      expect(result, equals('Recyclable'));
      });

      test('returns Hazardous when prediction is Battery', () async {
      final file = File('test/assets/battery.jpg');

      final result = await ApiService.classifyImage(file);
      expect(result, equals('Hazardous'));
      });

      test('returns Organic when prediction is Fruit', () async {
      final file = File('test/assets/fruit.jpg');

      final result = await ApiService.classifyImage(file);
      expect(result, equals('Organic'));
      });

      test('returns General when prediction is Wrapper', () async {
      final file = File('test/assets/wrapper.jpg');

      final result = await ApiService.classifyImage(file);
      expect(result, equals('General'));
      });
    });

    group('Unsuccessfully Case', (){
      test('returns Error with invalid file path', () async {
        final fakeFile = File('invalid_path.jpg');
        final result = await ApiService.classifyImage(fakeFile);

        expect(result, equals('Error'));
      });
    });
  });
}
