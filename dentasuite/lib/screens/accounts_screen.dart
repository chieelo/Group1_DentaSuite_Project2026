
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> accounts = [
    {
      'name': 'Alberta Assistant',
      'username': 'admin01',
      'email': 'admin@dentasuite.com',
      'role': 'Administrator',
      'status': 'Active',
    },
    {
      'name': 'Juan Dentist',
      'username': 'dentist01',
      'email': 'dentist@dentasuite.com',
      'role': 'Dentist',
      'status': 'Active',
    },
    {
      'name': 'Ana Assistant',
      'username': 'assistant01',
      'email': 'assistant@dentasuite.com',
      'role': 'Assistant',
      'status': 'Active',
    },
  ];

  List<Map<String, dynamic>> get filteredAccounts {
    final query = searchController.text.toLowerCase();

    return accounts.where((account) {
      return account['name'].toString().toLowerCase().contains(query) ||
          account['username'].toString().toLowerCase().contains(query) ||
          account['email'].toString().toLowerCase().contains(query) ||
          account['role'].toString().toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showAccountDialog({Map<String, dynamic>? account}) {
    final isEditing = account != null;

    final nameController = TextEditingController(
      text: account?['name'] ?? '',
    );
    final usernameController = TextEditingController(
      text: account?['username'] ?? '',
    );
    final emailController = TextEditingController(
      text: account?['email'] ?? '',
    );

    String selectedRole = account?['role'] ?? 'Assistant';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: Text(
                isEditing ? 'Edit Account' : 'Add Account',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogField(nameController, 'Full Name'),
                    const SizedBox(height: 12),
                    _dialogField(usernameController, 'Username'),
                    const SizedBox(height: 12),
                    _dialogField(emailController, 'Email Address'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Account Role',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Administrator',
                          child: Text('Administrator'),
                        ),
                        DropdownMenuItem(
                          value: 'Dentist',
                          child: Text('Dentist'),
                        ),
                        DropdownMenuItem(
                          value: 'Assistant',
                          child: Text('Assistant'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedRole = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D203B),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        usernameController.text.trim().isEmpty ||
                        emailController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      final newAccount = {
                        'name': nameController.text.trim(),
                        'username': usernameController.text.trim(),
                        'email': emailController.text.trim(),
                        'role': selectedRole,
                        'status': account?['status'] ?? 'Active',
                      };

                      if (isEditing) {
                        final index = accounts.indexOf(account);
                        if (index != -1) {
                          accounts[index] = newAccount;
                        }
                      } else {
                        accounts.add(newAccount);
                      }
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Add Account'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _dialogField(
    TextEditingController controller,
    String label,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void deleteAccount(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Are you sure you want to delete ${account['name']}?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  accounts.remove(account);
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0D203B);
    final mutedColor = isDark ? Colors.white60 : Colors.grey.shade600;

    final visibleAccounts = filteredAccounts;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Management',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Manage DentaSuite user accounts and access roles.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: mutedColor,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search accounts...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => showAccountDialog(),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text(
                    'Add Account',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D203B),
                    foregroundColor: const Color(0xFFC2FFE1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User Accounts',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    '${visibleAccounts.length} accounts',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: visibleAccounts.isEmpty
                    ? Center(
                        child: Text(
                          'No accounts found.',
                          style: GoogleFonts.poppins(color: mutedColor),
                        ),
                      )
                    : ListView.separated(
                        itemCount: visibleAccounts.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final account = visibleAccounts[index];

                          return Card(
                            color: Theme.of(context).cardColor,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFFC2FFE1),
                                        child: Text(
                                          account['name']
                                              .toString()
                                              .split(' ')
                                              .map((part) => part.isNotEmpty
                                                  ? part[0]
                                                  : '')
                                              .take(2)
                                              .join()
                                              .toUpperCase(),
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF0D203B),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              account['name'],
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700,
                                                color: textColor,
                                              ),
                                            ),
                                            Text(
                                              '@${account['username']}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: mutedColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            showAccountDialog(
                                              account: account,
                                            );
                                          } else if (value == 'delete') {
                                            deleteAccount(account);
                                          }
                                        },
                                        itemBuilder: (_) => const [
                                          PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    account['email'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: mutedColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      _roleChip(account['role']),
                                      const Spacer(),
                                      Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        account['status'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleChip(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFC2FFE1).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0D203B),
        ),
      ),
    );
  }
}
