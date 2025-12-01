import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../data/models/company_model.dart';
import '../../domain/repositories/company_repository.dart';

class CompanyController extends GetxController {
  final CompanyRepository _repository;

  CompanyController({required CompanyRepository repository})
      : _repository = repository;

  // Observable lists
  final RxList<CompanyModel> companies = <CompanyModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-fetch on init to avoid unnecessary API calls
  }

  Future<void> fetchCompanies() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log("========== FETCH COMPANIES ==========");

      final result = await _repository.getAllCompanies();

      result.fold(
        (failure) {
          DPrint.error("❌ Failed to fetch companies: ${failure.message}");
          errorMessage.value = failure.message;
          companies.clear();
        },
        (success) {
          DPrint.log("✅ Successfully fetched ${success.data.length} companies");
          companies.value = success.data;
          errorMessage.value = '';
        },
      );
    } catch (e) {
      DPrint.error("💥 Unexpected error in CompanyController: $e");
      errorMessage.value = 'An unexpected error occurred';
      companies.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Get company by ID
  CompanyModel? getCompanyById(String id) {
    try {
      return companies.firstWhere((company) => company.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get default company
  CompanyModel? getDefaultCompany() {
    try {
      return companies.firstWhere((company) => company.isDefault);
    } catch (e) {
      return null;
    }
  }

  /// Get company names for dropdown (unique names only)
  List<String> get companyNames {
    final uniqueNames = <String>{};
    final names = <String>[];
    
    for (var company in companies) {
      if (!uniqueNames.contains(company.name)) {
        uniqueNames.add(company.name);
        names.add(company.name);
      }
    }
    
    return names;
  }

  /// Get display names with ID for dropdown (to handle duplicates)
  List<Map<String, String>> get companyDisplayItems {
    final Map<String, int> nameCount = {};
    final List<Map<String, String>> items = [];
    
    // First pass: count occurrences of each name
    for (var company in companies) {
      nameCount[company.name] = (nameCount[company.name] ?? 0) + 1;
    }
    
    // Second pass: create display names
    final Map<String, int> nameIndex = {};
    for (var company in companies) {
      final baseLabel = company.name;
      String displayLabel = baseLabel;
      
      if (nameCount[baseLabel]! > 1) {
        nameIndex[baseLabel] = (nameIndex[baseLabel] ?? 0) + 1;
        displayLabel = '$baseLabel (${company.id.substring(company.id.length - 4)})';
      }
      
      items.add({
        'id': company.id,
        'name': company.name,
        'display': displayLabel,
      });
    }
    
    return items;
  }

  /// Get company ID by name
  String? getCompanyIdByName(String name) {
    try {
      final company = companies.firstWhere((company) => company.name == name);
      return company.id;
    } catch (e) {
      return null;
    }
  }
}