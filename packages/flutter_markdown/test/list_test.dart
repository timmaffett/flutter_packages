// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown/markdown.dart'
    show indicatorForUncheckedCheckBox, indicatorForCheckedCheckBox;
import 'utils.dart';

void main() => defineTests();

void defineTests() {
  group('Unordered List', () {
    testWidgets(
      'simple 3 item list',
      (WidgetTester tester) async {
        const String data = '- Item 1\n- Item 2\n- Item 3';
        await tester.pumpWidget(
          boilerplate(
            const MarkdownBody(data: data),
          ),
        );

        final Iterable<Widget> widgets = tester.allWidgets;
        expectTextStrings(widgets, <String>[
          '•',
          'Item 1',
          '•',
          'Item 2',
          '•',
          'Item 3',
        ]);
      },
    );

    testWidgets(
      'empty list item',
      (WidgetTester tester) async {
        const String data = '- \n- Item 2\n- Item 3';
        await tester.pumpWidget(
          boilerplate(
            const MarkdownBody(data: data),
          ),
        );

        final Iterable<Widget> widgets = tester.allWidgets;
        expectTextStrings(widgets, <String>[
          '•',
          '•',
          'Item 2',
          '•',
          'Item 3',
        ]);
      },
    );

    testWidgets(
        // Example 236 from the GitHub Flavored Markdown specification.
        'leading space are ignored', (WidgetTester tester) async {
      const String data = ' -    one\n\n        two';
      await tester.pumpWidget(
        boilerplate(
          const MarkdownBody(data: data),
        ),
      );

      final Iterable<Widget> widgets = tester.allWidgets;
      expectTextStrings(widgets, <String>[
        '•',
        'one',
        'two',
      ]);
    });
  });

  group('Ordered List', () {
    testWidgets(
      '2 distinct ordered lists with separate index values',
      (WidgetTester tester) async {
        const String data = '1. Item 1\n1. Item 2\n2. Item 3\n\n\n'
            '10. Item 10\n13. Item 11';
        await tester.pumpWidget(
          boilerplate(
            const MarkdownBody(data: data),
          ),
        );

        final Iterable<Widget> widgets = tester.allWidgets;
        expectTextStrings(widgets, <String>[
          '1.',
          'Item 1',
          '2.',
          'Item 2',
          '3.',
          'Item 3',
          '10.',
          'Item 10',
          '11.',
          'Item 11'
        ]);
      },
    );

    testWidgets('leading space are ignored', (WidgetTester tester) async {
      const String data = ' 1.    one\n\n       two';
      await tester.pumpWidget(
        boilerplate(
          const MarkdownBody(data: data),
        ),
      );

      final Iterable<Widget> widgets = tester.allWidgets;
      expectTextStrings(widgets, <String>['1.', 'one', 'two']);
    });
  });

  group('Task List', () {
    testWidgets(
      'simple 2 item task list',
      (WidgetTester tester) async {
        const String data = '- [x] Item 1\n- [ ] Item 2';
        await tester.pumpWidget(
          boilerplate(
            const MarkdownBody(data: data),
          ),
        );

        final Iterable<Widget> widgets = tester.allWidgets;

        expectTextStrings(widgets, <String>[
          String.fromCharCode(Icons.check_box.codePoint),
          '${indicatorForCheckedCheckBox}Item 1',
          String.fromCharCode(Icons.check_box_outline_blank.codePoint),
          '${indicatorForUncheckedCheckBox}Item 2',
        ]);
      },
    );

    testWidgets('custom bullet builder', (WidgetTester tester) async {
      const String data = '* Item 1\n* Item 2\n1) Item 3\n2) Item 4';
      Widget builder(int index, BulletStyle style) => Text(
          '$index ${style == BulletStyle.orderedList ? 'ordered' : 'unordered'}');

      await tester.pumpWidget(
        boilerplate(
          Markdown(data: data, bulletBuilder: builder),
        ),
      );

      final Iterable<Widget> widgets = tester.allWidgets;

      expectTextStrings(widgets, <String>[
        '0 unordered',
        'Item 1',
        '1 unordered',
        'Item 2',
        '0 ordered',
        'Item 3',
        '1 ordered',
        'Item 4',
      ]);
    });

    testWidgets(
      'custom checkbox builder',
      (WidgetTester tester) async {
        const String data = '- [x] Item 1\n- [ ] Item 2';
        Widget builder(bool checked) => Text('$checked');

        await tester.pumpWidget(
          boilerplate(
            Markdown(data: data, checkboxBuilder: builder),
          ),
        );

        final Iterable<Widget> widgets = tester.allWidgets;

        expectTextStrings(widgets, <String>[
          'true',
          '${indicatorForCheckedCheckBox}Item 1',
          'false',
          '${indicatorForUncheckedCheckBox}Item 2',
        ]);
      },
    );
  });
}
