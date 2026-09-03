import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class MembershipRequestPage extends StatefulWidget {
  const MembershipRequestPage({
    super.key,
  });

  @override
  State<MembershipRequestPage> createState() => _MembershipRequestPageState();
}

class _MembershipRequestPageState extends State<MembershipRequestPage> {
  final _formKey = GlobalKey<FormState>();

  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TextEditingController _birthPlaceController = TextEditingController();

  final TextEditingController _nationalityController =
      TextEditingController(text: 'Nigérienne');

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _regionController = TextEditingController();

  final TextEditingController _departmentController = TextEditingController();

  final TextEditingController _communeController = TextEditingController();

  final TextEditingController _villageController = TextEditingController();

  final TextEditingController _professionController = TextEditingController();

  final TextEditingController _educationController = TextEditingController();

  final TextEditingController _skillsController = TextEditingController();

  final TextEditingController _motivationController = TextEditingController();

  final TextEditingController _messageController = TextEditingController();

  final TextEditingController _photoUrlController = TextEditingController();

  final TextEditingController _receiptReferenceController =
      TextEditingController();

  final TextEditingController _receiptUrlController = TextEditingController();

  // ==========================================================
  // ETAT
  // ==========================================================

  bool _loading = true;
  bool _sending = false;

  String? _gender;
  String? _requestedStatus;

  DateTime? _birthDate;

  bool _statutesAccepted = false;
  bool _declarationAccepted = false;

  List<Map<String, dynamic>> _requests = [];

  // ==========================================================
  // INIT / DISPOSE
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _birthPlaceController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _departmentController.dispose();
    _communeController.dispose();
    _villageController.dispose();
    _professionController.dispose();
    _educationController.dispose();
    _skillsController.dispose();
    _motivationController.dispose();
    _messageController.dispose();
    _photoUrlController.dispose();
    _receiptReferenceController.dispose();
    _receiptUrlController.dispose();

    super.dispose();
  }

  // ==========================================================
  // CHARGER LES DEMANDES
  // ==========================================================

  Future<void> _loadRequests() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    try {
      final response = await ApiService.get('/membership/mine');

      if (!mounted) {
        return;
      }

      final List<Map<String, dynamic>> requests = [];

      if (response is List) {
        for (final item in response) {
          if (item is Map) {
            requests.add(
              Map<String, dynamic>.from(item),
            );
          }
        }
      }

      setState(() {
        _requests = requests;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
      });

      _showError(e.message);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
      });

      _showError(
        'Impossible de charger vos demandes : $e',
      );
    }
  }

  // ==========================================================
  // DATE DE NAISSANCE
  // ==========================================================

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();

    final firstDate = DateTime(
      now.year - 100,
      1,
      1,
    );

    final lastDate = DateTime(
      now.year - 10,
      now.month,
      now.day,
    );

    final defaultDate = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );

    DateTime initialDate = _birthDate ?? defaultDate;

    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    if (initialDate.isAfter(lastDate)) {
      initialDate = lastDate;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Sélectionner la date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
      locale: const Locale('fr', 'FR'),
    );

    if (selectedDate != null && mounted) {
      setState(() {
        _birthDate = selectedDate;
      });
    }
  }

  // ==========================================================
  // FORMAT DATE
  // ==========================================================

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _formatDateForApi(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  // ==========================================================
  // ENVOYER LA DEMANDE
  // ==========================================================

  Future<void> _sendRequest() async {
    if (_sending) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_gender == null) {
      _showError('Veuillez sélectionner votre sexe.');
      return;
    }

    if (_birthDate == null) {
      _showError(
        'Veuillez sélectionner votre date de naissance.',
      );
      return;
    }

    if (_requestedStatus == null) {
      _showError(
        'Veuillez sélectionner le statut demandé.',
      );
      return;
    }

    if (!_statutesAccepted) {
      _showError(
        'Vous devez accepter les statuts du MNPC-SABOUWA.',
      );
      return;
    }

    if (!_declarationAccepted) {
      _showError(
        'Vous devez confirmer l’exactitude de vos informations.',
      );
      return;
    }

    setState(() {
      _sending = true;
    });

    try {
      await ApiService.post(
        '/membership/',
        {
          'organization_unit_id': null,

          // Informations personnelles
          'gender': _gender,
          'birth_date': _formatDateForApi(_birthDate!),
          'birth_place': _birthPlaceController.text.trim(),
          'nationality': _nationalityController.text.trim(),

          // Adresse
          'address': _addressController.text.trim(),
          'region': _regionController.text.trim(),
          'department': _departmentController.text.trim(),
          'commune': _communeController.text.trim(),
          'village_quartier': _villageController.text.trim(),

          // Informations professionnelles
          'profession': _professionController.text.trim(),
          'education_level': _educationController.text.trim(),
          'skills_experience': _skillsController.text.trim(),
          'requested_status': _requestedStatus,
          'motivation': _motivationController.text.trim(),

          // Message complémentaire
          'message': _messageController.text.trim(),

          // Photo
          'photo_url': _photoUrlController.text.trim().isEmpty
              ? null
              : _photoUrlController.text.trim(),

          // Déclarations
          'statutes_accepted': _statutesAccepted,
          'declaration_accepted': _declarationAccepted,

          // Cotisation obligatoire
          'card_fee': 2000.0,

          // Paiement en attente de vérification
          'payment_status': 'PENDING',

          // Justificatif
          'receipt_reference': _receiptReferenceController.text.trim().isEmpty
              ? null
              : _receiptReferenceController.text.trim(),

          'receipt_url': _receiptUrlController.text.trim().isEmpty
              ? null
              : _receiptUrlController.text.trim(),
        },
      );

      if (!mounted) {
        return;
      }

      await _loadRequests();

      if (!mounted) {
        return;
      }

      _clearForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
          content: Text(
            'Votre demande d’adhésion a été envoyée avec succès.',
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      _showError(e.message);
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showError(
        'Erreur lors de l’envoi de la demande : $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  // ==========================================================
  // NETTOYER LE FORMULAIRE
  // ==========================================================

  void _clearForm() {
    _birthPlaceController.clear();
    _addressController.clear();
    _regionController.clear();
    _departmentController.clear();
    _communeController.clear();
    _villageController.clear();
    _professionController.clear();
    _educationController.clear();
    _skillsController.clear();
    _motivationController.clear();
    _messageController.clear();
    _photoUrlController.clear();
    _receiptReferenceController.clear();
    _receiptUrlController.clear();

    setState(() {
      _gender = null;
      _requestedStatus = null;
      _birthDate = null;
      _statutesAccepted = false;
      _declarationAccepted = false;
    });
  }

  // ==========================================================
  // MESSAGE ERREUR
  // ==========================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        content: Text(message),
      ),
    );
  }

  // ==========================================================
  // VALIDATION CHAMP
  // ==========================================================

  String? _requiredValidator(
    String? value,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est obligatoire.';
    }

    return null;
  }

  // ==========================================================
  // COULEUR STATUT
  // ==========================================================

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;

      case 'REJECTED':
        return Colors.red;

      case 'PENDING':
      default:
        return Colors.orange;
    }
  }

  // ==========================================================
  // LABEL STATUT
  // ==========================================================

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return 'Demande approuvée';

      case 'REJECTED':
        return 'Demande rejetée';

      case 'PENDING':
      default:
        return 'Demande en attente';
    }
  }

  // ==========================================================
  // ICONE STATUT
  // ==========================================================

  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Icons.check_circle_outline;

      case 'REJECTED':
        return Icons.cancel_outlined;

      case 'PENDING':
      default:
        return Icons.hourglass_empty;
    }
  }

  // ==========================================================
  // DEMANDE EN ATTENTE
  // ==========================================================

  bool get _hasPendingRequest {
    return _requests.any(
      (request) => request['status']?.toString().toUpperCase() == 'PENDING',
    );
  }

  // ==========================================================
  // DEMANDE APPROUVEE
  // ==========================================================

  bool get _hasApprovedRequest {
    return _requests.any(
      (request) => request['status']?.toString().toUpperCase() == 'APPROVED',
    );
  }

  // ==========================================================
  // CARTE STATUT
  // ==========================================================

  Widget _buildStatusCard(
    Map<String, dynamic> request,
  ) {
    final status = request['status']?.toString().toUpperCase() ?? 'PENDING';

    final color = _statusColor(status);

    final requestMessage = request['message']?.toString();

    final createdAt = request['created_at']?.toString();

    final paymentStatus =
        request['payment_status']?.toString().toUpperCase() ?? 'PENDING';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _statusIcon(status),
                color: color,
                size: 32,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _statusLabel(status),
                      style: TextStyle(
                        color: color,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (createdAt != null && createdAt.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Date : $createdAt',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 22,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Paiement : ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    paymentStatus == 'PAID'
                        ? 'Vérifié'
                        : 'En attente de vérification',
                    style: TextStyle(
                      color: paymentStatus == 'PAID'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (requestMessage != null && requestMessage.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              requestMessage,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // CHAMP TEXTE
  // ==========================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // TITRE DE SECTION
  // ==========================================================

  Widget _buildSectionTitle(
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 14,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 23,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FORMULAIRE
  // ==========================================================

  Widget _buildRequestForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            '1. Informations personnelles',
            Icons.person_outline,
          ),

          // SEXE
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DropdownButtonFormField<String>(
              initialValue: _gender,
              decoration: InputDecoration(
                labelText: 'Sexe',
                prefixIcon: const Icon(
                  Icons.wc_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'MASCULIN',
                  child: Text('Masculin'),
                ),
                DropdownMenuItem(
                  value: 'FEMININ',
                  child: Text('Féminin'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _gender = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner votre sexe.';
                }
                return null;
              },
            ),
          ),

          // DATE DE NAISSANCE
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: _selectBirthDate,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date de naissance',
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _birthDate == null
                      ? 'Sélectionner la date'
                      : _formatDate(_birthDate!),
                  style: TextStyle(
                    color: _birthDate == null ? Colors.black54 : Colors.black,
                  ),
                ),
              ),
            ),
          ),

          _buildTextField(
            controller: _birthPlaceController,
            label: 'Lieu de naissance',
            icon: Icons.location_on_outlined,
            validator: (value) => _requiredValidator(
              value,
              'Le lieu de naissance',
            ),
          ),

          _buildTextField(
            controller: _nationalityController,
            label: 'Nationalité',
            icon: Icons.flag_outlined,
            validator: (value) => _requiredValidator(
              value,
              'La nationalité',
            ),
          ),

          const SizedBox(height: 8),

          _buildSectionTitle(
            '2. Adresse et localisation',
            Icons.location_on_outlined,
          ),

          _buildTextField(
            controller: _addressController,
            label: 'Adresse',
            hint: 'Quartier, rue ou adresse complète',
            icon: Icons.home_outlined,
            maxLines: 2,
            validator: (value) => _requiredValidator(
              value,
              'L’adresse',
            ),
          ),

          _buildTextField(
            controller: _regionController,
            label: 'Région',
            icon: Icons.map_outlined,
            validator: (value) => _requiredValidator(
              value,
              'La région',
            ),
          ),

          _buildTextField(
            controller: _departmentController,
            label: 'Département',
            icon: Icons.account_tree_outlined,
            validator: (value) => _requiredValidator(
              value,
              'Le département',
            ),
          ),

          _buildTextField(
            controller: _communeController,
            label: 'Commune',
            icon: Icons.location_city_outlined,
            validator: (value) => _requiredValidator(
              value,
              'La commune',
            ),
          ),

          _buildTextField(
            controller: _villageController,
            label: 'Village / Quartier',
            icon: Icons.place_outlined,
            validator: (value) => _requiredValidator(
              value,
              'Le village ou quartier',
            ),
          ),

          const SizedBox(height: 8),

          _buildSectionTitle(
            '3. Informations professionnelles',
            Icons.work_outline,
          ),

          _buildTextField(
            controller: _professionController,
            label: 'Profession',
            icon: Icons.work_outline,
            validator: (value) => _requiredValidator(
              value,
              'La profession',
            ),
          ),

          _buildTextField(
            controller: _educationController,
            label: 'Niveau d’étude',
            icon: Icons.school_outlined,
            validator: (value) => _requiredValidator(
              value,
              'Le niveau d’étude',
            ),
          ),

          _buildTextField(
            controller: _skillsController,
            label: 'Compétences / expériences',
            hint: 'Responsabilités, compétences ou expériences',
            icon: Icons.psychology_outlined,
            maxLines: 4,
          ),

          // STATUT DEMANDE
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DropdownButtonFormField<String>(
              initialValue: _requestedStatus,
              decoration: InputDecoration(
                labelText: 'Statut demandé',
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'MILITANT',
                  child: Text('Militant'),
                ),
                DropdownMenuItem(
                  value: 'RESPONSABLE',
                  child: Text('Responsable'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _requestedStatus = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner le statut demandé.';
                }
                return null;
              },
            ),
          ),

          _buildTextField(
            controller: _motivationController,
            label: 'Motivation',
            hint: 'Pourquoi souhaitez-vous adhérer au MNPC-SABOUWA ?',
            icon: Icons.lightbulb_outline,
            maxLines: 5,
            validator: (value) => _requiredValidator(
              value,
              'La motivation',
            ),
          ),

          const SizedBox(height: 8),

          _buildSectionTitle(
            '4. Photo d’identité',
            Icons.photo_camera_outlined,
          ),

          _buildTextField(
            controller: _photoUrlController,
            label: 'Lien de la photo',
            hint: 'URL de la photo si disponible',
            icon: Icons.image_outlined,
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'La photo sera associée à votre demande '
                    'd’adhésion. Le système d’envoi direct du '
                    'fichier sera raccordé au module de documents.',
                  ),
                ),
              ],
            ),
          ),

          _buildSectionTitle(
            '5. Cotisation et paiement',
            Icons.payments_outlined,
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.25),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cotisation d’adhésion',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '2 000 F CFA',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Le paiement sera vérifié par l’administration '
                  'avant l’approbation définitive.',
                ),
              ],
            ),
          ),

          _buildTextField(
            controller: _receiptReferenceController,
            label: 'Référence du paiement',
            hint: 'Numéro ou référence de la transaction',
            icon: Icons.receipt_long_outlined,
          ),

          _buildTextField(
            controller: _receiptUrlController,
            label: 'Lien du justificatif',
            hint: 'URL du reçu si disponible',
            icon: Icons.attach_file_outlined,
          ),

          const SizedBox(height: 8),

          _buildSectionTitle(
            '6. Déclarations',
            Icons.verified_user_outlined,
          ),

          CheckboxListTile(
            value: _statutesAccepted,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'J’accepte les statuts et les règles '
              'du MNPC-SABOUWA.',
            ),
            onChanged: (bool? value) {
              setState(() {
                _statutesAccepted = value ?? false;
              });
            },
          ),

          CheckboxListTile(
            value: _declarationAccepted,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'Je certifie que les informations fournies '
              'sont exactes.',
            ),
            onChanged: (bool? value) {
              setState(() {
                _declarationAccepted = value ?? false;
              });
            },
          ),

          const SizedBox(height: 8),

          _buildSectionTitle(
            '7. Message complémentaire',
            Icons.message_outlined,
          ),

          _buildTextField(
            controller: _messageController,
            label: 'Message',
            hint: 'Informations complémentaires, si nécessaire',
            icon: Icons.message_outlined,
            maxLines: 5,
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              onPressed: _sending ? null : _sendRequest,
              icon: _sending
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send_outlined,
                    ),
              label: Text(
                _sending ? 'Envoi en cours...' : 'Soumettre ma demande',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              'Après l’envoi, votre demande sera examinée '
              'par l’administration.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFB00020),
            Color(0xFF1B7F35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.how_to_reg_outlined,
            color: Colors.white,
            size: 48,
          ),
          SizedBox(height: 12),
          Text(
            'Adhésion MNPC-SABOUWA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Remplissez le formulaire officiel d’adhésion '
            'avec vos informations exactes. Votre demande '
            'sera examinée par l’administration.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INFORMATION EN ATTENTE
  // ==========================================================

  Widget _buildPendingInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.schedule,
            color: Colors.orange,
            size: 30,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Votre demande est actuellement en cours '
              'd’examen par l’administration. Le paiement '
              'doit également être vérifié.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INFORMATION APPROUVEE
  // ==========================================================

  Widget _buildApprovedInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified,
            color: Colors.green,
            size: 30,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Votre demande a été approuvée. '
              'Vous êtes maintenant membre actif '
              'du MNPC-SABOUWA.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INTERFACE
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Demande d’adhésion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadRequests,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              if (_loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                if (_requests.isNotEmpty) ...[
                  const Text(
                    'Mes demandes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._requests.map(
                    _buildStatusCard,
                  ),
                  const SizedBox(height: 10),
                ],
                if (_hasApprovedRequest)
                  _buildApprovedInformation()
                else if (_hasPendingRequest)
                  _buildPendingInformation()
                else
                  _buildRequestForm(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
