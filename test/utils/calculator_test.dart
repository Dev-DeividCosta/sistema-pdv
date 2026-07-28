import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_template/utils/calculator.dart';

void main() {
  group('Calculator Tests', () {
    late Calculator calculator;

    setUp(() {
      calculator = Calculator();
    });

    test('deve retornar 4 quando somar 2 + 2', () {
      final result = calculator.add(2, 2);
      expect(result, 4);
    });
  });
}