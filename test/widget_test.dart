import 'package:flutter_test/flutter_test.dart';

import 'package:mnpc_sabouwa/main.dart';

void main() {
  testWidgets('MNPC SABOUWA affiche la page de connexion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MnpcSabouwaApp());

    expect(find.text('Connexion MNPC SABOUWA'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
