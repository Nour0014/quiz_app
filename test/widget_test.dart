import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('Quiz app launches and works perfectly', (WidgetTester tester) async {
    // MyApp est maintenant const → plus d'erreur !
    await tester.pumpWidget(const MyApp());

    // Attendre le chargement complet de la base SQLite et de la première question
    await tester.pumpAndSettle();

    // Vérifications de l'énoncé
    expect(find.textContaining('Temps restant'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(4)); // 4 options
    expect(find.text('Suivant'), findsOneWidget);

    // Bouton Suivant désactivé au début (spécification page 2)
    expect(tester.widget<ElevatedButton>(find.text('Suivant')).enabled, false);

    // Sélectionner une réponse
    await tester.tap(find.byType(ListTile).first);
    await tester.pump();

    // Bouton Suivant devient actif
    expect(tester.widget<ElevatedButton>(find.text('Suivant')).enabled, true);
  });
}