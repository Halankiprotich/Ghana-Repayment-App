import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/helpers.dart';

class CreateLinkScreen extends StatefulWidget {
  const CreateLinkScreen({super.key});

  @override
  State<CreateLinkScreen> createState() => _CreateLinkScreenState();
}

class _CreateLinkScreenState extends State<CreateLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _borrowerNameController = TextEditingController();
  final _borrowerPhoneController = TextEditingController();
  final _borrowerEmailController = TextEditingController();
  final _loanReferenceController = TextEditingController();
  final _principalController = TextEditingController();
  final _interestController = TextEditingController();
  final _feesController = TextEditingController();
  final _totalController = TextEditingController();
  final _noteController = TextEditingController();
  final _walletController = TextEditingController();
  final _companyNameController = TextEditingController();

  DateTime? _dueDate;
  int _expiryDays = 30;
  String _selectedNetwork = 'MTN';
  bool _isLoading = false;

  final List<String> _networks = ['MTN', 'VODAFONE', 'AIRTELTIGO', 'TELECEL', 'GHANAPAY', 'ALL'];

  @override
  void dispose() {
    _borrowerNameController.dispose();
    _borrowerPhoneController.dispose();
    _borrowerEmailController.dispose();
    _loanReferenceController.dispose();
    _principalController.dispose();
    _interestController.dispose();
    _feesController.dispose();
    _totalController.dispose();
    _noteController.dispose();
    _walletController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final interest = double.tryParse(_interestController.text) ?? 0;
    final fees = double.tryParse(_feesController.text) ?? 0;
    final total = principal + interest + fees;
    _totalController.text = total.toStringAsFixed(2);
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _createLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final apiService = ApiService();

      final data = {
        'borrowerName': _borrowerNameController.text.trim(),
        'borrowerPhone': _borrowerPhoneController.text.trim(),
        'borrowerEmail': _borrowerEmailController.text.trim(),
        'loanReference': _loanReferenceController.text.trim(),
        'dueDate': _dueDate?.toIso8601String().split('T')[0],
        'expiryDays': _expiryDays,
        'principalAmount': double.tryParse(_principalController.text) ?? 0,
        'interestAmount': double.tryParse(_interestController.text) ?? 0,
        'feesAmount': double.tryParse(_feesController.text) ?? 0,
        'totalAmount': double.tryParse(_totalController.text) ?? 0,
        'network': _selectedNetwork,
        'walletNumber': _walletController.text.trim(),
        'note': _noteController.text.trim(),
        'companyName': _companyNameController.text.trim(),
      };

      try {
        final response = await apiService.createLink(data, authProvider.token!);

        if (mounted) {
          _showLinkModal(response['repaymentUrl']);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString().split(':').last}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showLinkModal(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Repayment Link Generated!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.link, size: 48, color: Color(0xFF006B3F)),
            const SizedBox(height: 16),
            Text(
              url,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Helpers.copyToClipboard(url, context),
              icon: const Icon(Icons.copy),
              label: const Text('Copy Link'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Repayment Link'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Network Selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Mobile Money Network',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: _networks.map((network) {
                        return ChoiceChip(
                          label: Text(network),
                          selected: _selectedNetwork == network,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedNetwork = network);
                            }
                          },
                          selectedColor: const Color(0xFF006B3F),
                          labelStyle: TextStyle(
                            color: _selectedNetwork == network ? Colors.white : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Borrower Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Borrower Details',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _borrowerNameController,
                      label: 'Borrower Name *',
                      prefixIcon: Icons.person_outline,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _borrowerPhoneController,
                      label: 'Borrower Phone',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _borrowerEmailController,
                      label: 'Borrower Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _loanReferenceController,
                      label: 'Loan Reference *',
                      prefixIcon: Icons.receipt_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _selectDueDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Due Date',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _dueDate != null
                              ? Helpers.formatDate(_dueDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: _expiryDays.toString()),
                            label: 'Expiry (days)',
                            keyboardType: TextInputType.number,
                            onChanged: (v) => _expiryDays = int.tryParse(v) ?? 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Loan Amounts
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loan Amounts (GHS)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _principalController,
                      label: 'Principal Amount *',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateTotal(),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _interestController,
                      label: 'Interest Amount',
                      prefixIcon: Icons.trending_up,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateTotal(),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _feesController,
                      label: 'Fees / Charges',
                      prefixIcon: Icons.receipt,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateTotal(),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _totalController,
                      label: 'Total Repayment *',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Additional Options
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional Options',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _noteController,
                      label: 'Payment Note',
                      prefixIcon: Icons.note_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _walletController,
                      label: 'Override Wallet Number (Optional)',
                      prefixIcon: Icons.account_balance_wallet_outlined,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _companyNameController,
                      label: 'Company Name (for repayment page)',
                      prefixIcon: Icons.business,
                      hintText: 'e.g., Zigwe Loans',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Generate Repayment Link',
                onPressed: _createLink,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}