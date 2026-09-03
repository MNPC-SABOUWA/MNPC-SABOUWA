import 'package:flutter/material.dart';

import '../models/document_model.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({
    super.key,
  });

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  bool loading = false;

  final List<DocumentModel> documents = [
    const DocumentModel(
      id: '1',
      title: 'Statuts MNPC SABOUWA',
      category: 'Statuts',
      type: 'PDF',
      description: 'Document officiel de l organisation.',
      createdAt: '2026',
    ),
    const DocumentModel(
      id: '2',
      title: 'Rapport annuel',
      category: 'Rapports',
      type: 'PDF',
      description: 'Rapport des activités de la coordination.',
      createdAt: '2026',
    ),
    const DocumentModel(
      id: '3',
      title: 'Décision administrative',
      category: 'Décisions',
      type: 'PDF',
      description: 'Décisions officielles de l administration.',
      createdAt: '2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Documents MNPC SABOUWA',
        ),
        centerTitle: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(
                    bottom: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F5E9),
                      child: Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(
                      document.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.category,
                        ),
                        Text(
                          document.description ?? 'Document officiel',
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.download,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Téléchargement du document',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
