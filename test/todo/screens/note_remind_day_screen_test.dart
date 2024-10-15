import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:remindday_app/todo/controllers/note_controller.dart';
import 'package:remindday_app/todo/models/note_model.dart';
import 'package:remindday_app/todo/screens/note_remind_day_screen.dart';
import 'package:remindday_app/todo/widgets/custom_dropdown.dart';

import 'note_remind_day_screen.mocks.dart';

@GenerateMocks([TodoController])
void main() {
  late MockTodoController mockTodoController;

  setUp(() {
    mockTodoController = MockTodoController();
  });

  testWidgets('NoteRemindDayScreen UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NoteRemindDayScreen(selectedDate: DateTime.now()),
      ),
    );

    expect(find.text('เพิ่มรายการใหม่'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));
    expect(find.byType(CustomDropdown), findsNWidgets(4));

    await tester.enterText(find.byKey(const Key('title_field')), 'Test Todo');
    expect(find.text('Test Todo'), findsOneWidget);

    await tester.tap(find.byKey(const Key('type_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('เรียน').last);
    await tester.pumpAndSettle();
    expect(find.text('เรียน'), findsOneWidget);

    await tester.tap(find.text('เพิ่มข้อมูล'));
    await tester.pumpAndSettle();

    expect(find.text('กรุณากรอกชื่องาน'), findsNothing);
    expect(find.text('กรุณาเลือกข้อมูล'), findsNWidgets(3));
  });

  testWidgets('NoteRemindDayScreen Date Picker Test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NoteRemindDayScreen(selectedDate: DateTime(2024, 10, 15)),
      ),
    );

    expect(find.text('15/10/2024'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(find.text('20'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // ตรวจสอบว่าวันที่ถูกอัปเดตในฟอร์ม
    expect(find.text('20/10/2024'), findsOneWidget);
  });

  testWidgets('NoteRemindDayScreen Form Submission Test',
      (WidgetTester tester) async {
    when(mockTodoController.getidDevice())
        .thenAnswer((_) async => 'test_device_id');
    when(mockTodoController.addTodo(any)).thenAnswer((_) async => {});

    await tester.pumpWidget(
      MaterialApp(
        home: NoteRemindDayScreen(selectedDate: DateTime.now()),
      ),
    );

    await tester.enterText(find.byKey(const Key('title_field')), 'Test Todo');
    await tester.enterText(
        find.byKey(const Key('description_field')), 'Test Description');

    await tester.tap(find.byKey(const Key('type_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('เรียน').last);
    await tester.pumpAndSettle();
    expect(find.text('เรียน'), findsOneWidget);

    await tester.tap(find.byKey(const Key('importance_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('สำคัญมาก'));
    await tester.pumpAndSettle();
    expect(find.text('สำคัญมาก'), findsOneWidget);

    await tester.tap(find.byKey(const Key('start_time_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('07:00'));
    await tester.pumpAndSettle();
    expect(find.text('07:00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('notify_minutes_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15 นาที'));
    await tester.pumpAndSettle();
    expect(find.text('15 นาที'), findsOneWidget);

    await tester.tap(find.byKey(const Key('submitForm')));
    await tester.pump();
    expect(find.text('เพิ่มรายการสำเร็จ'), findsOneWidget);
  });
}
