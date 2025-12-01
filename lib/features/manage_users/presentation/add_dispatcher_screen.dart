import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/network/services/auth_storage_service.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/features/driver_company_page/presentation/controllers/add_dispatcher_controller.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../widgets/user_form.dart';

class AddDispatcherScreen extends StatefulWidget {
  const AddDispatcherScreen({super.key});

  @override
  State<AddDispatcherScreen> createState() => _AddDispatcherScreenState();
}

class _AddDispatcherScreenState extends State<AddDispatcherScreen> {
  final AddDispatcherController _addDispatcherController = AddDispatcherController();
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  
  String _companyIdHint = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadCompanyId();
  }

  Future<void> _loadCompanyId() async {
    final companyId = await _authStorageService.getCompanyId();
    if (companyId != null && companyId.isNotEmpty) {
      setState(() {
        _companyController.text = companyId;
        _companyIdHint = companyId;
      });
    } else {
      setState(() {
        _companyIdHint = 'Company ID not found';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    // Keep company ID populated from login
    _loadCompanyId();
  }

  void _handleAddDispatcher() {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter dispatcher name');
      return;
    }
    
    if (_emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter email');
      return;
    }
    
    if (_phoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter phone number');
      return;
    }
    
    if (_passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter password');
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    
    if (_companyController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter company ID');
      return;
    }

    // Call API
    _addDispatcherController.createDispatcher(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      company: _companyController.text.trim(),
    ).then((_) {
      // Clear form after successful creation
      _clearForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Add Dispatcher",
          titleCenter: true,
        ),
      ),
      body: AnimatedBuilder(
        animation: _addDispatcherController,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                
                UserForm(
                  title: 'Name',
                  controller: _nameController,
                  hintText: 'Enter dispatcher name',
                ),
                const SizedBox(height: 16),
                
                UserForm(
                  title: 'Email',
                  controller: _emailController,
                  hintText: 'Enter email address',
                ),
                const SizedBox(height: 16),
                
                UserForm(
                  title: 'Phone',
                  controller: _phoneController,
                  hintText: 'Enter phone number',
                ),
                const SizedBox(height: 16),
                
                UserForm(
                  title: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  hintText: 'Enter password',
                ),
                const SizedBox(height: 16),
                
                UserForm(
                  title: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  hintText: 'Confirm password',
                ),
                const SizedBox(height: 16),
                
                UserForm(
                  title: 'Company ID',
                  controller: _companyController,
                  hintText: _companyIdHint,
                  readOnly: true,
                ),
                const SizedBox(height: 36),
                
                // Add Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: const Color(0xFFFFFFFF),
                      padding: const EdgeInsets.symmetric(vertical: 12.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _addDispatcherController.isLoading 
                        ? null 
                        : _handleAddDispatcher,
                    child: _addDispatcherController.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}



