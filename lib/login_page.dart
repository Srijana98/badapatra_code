import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'final_homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Login Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final url = Uri.parse("https://digitalbadapatra.com/api/v1/login");

      print("🚀 Sending login request to: $url");
      print("📧 Email: $username");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": username, "password": password}),
      );

      print("📡 Status Code: ${response.statusCode}");

      if (response.statusCode != 200) {
        _showError("Server error: ${response.statusCode}");
        return;
      }

      // Parse JSON response
      final jsonResponse = jsonDecode(response.body);
      print("✅ API RESPONSE STATUS: ${jsonResponse["status"]}");

      if (jsonResponse["status"] == "success") {
        // Debug: Print user info
        print("👤 User Info: ${jsonResponse["user_info"]}");
        print("🏢 Org Info: ${jsonResponse["organization_info"]}");

        // ✅ FIXED: Extract userid (not id) from user_info
        String userId = '';
        if (jsonResponse["user_info"]?["userid"] != null) {
          userId = jsonResponse["user_info"]["userid"].toString();
        } else if (jsonResponse["user_info"]?["id"] != null) {
          userId = jsonResponse["user_info"]["id"].toString();
        }

        final orgCode =
            jsonResponse["organization_info"]?["org_code"]?.toString() ?? '';
            final orgId = jsonResponse["user_info"]?["orgid"]?.toString() ?? '';

       final badapatradata = jsonResponse["badapatradata"] ?? [];
        final teams = jsonResponse["teams"] ?? [];
        final token = jsonResponse["token"]?.toString() ?? '';
       // final displayHeadingData = jsonResponse["badapatradata_display_heading"];
       final displayHeadingData = jsonResponse["badapatradata_display_heading"] as Map<String, dynamic>?;
       final gallery = jsonResponse["gallery"] ?? []; 
        print("📊 Display Heading Data: $displayHeadingData");


       // final orgId = orgCode;

    
        print("🔍 Extracted userId: '$userId'");
        print("🔍 Extracted orgCode: '$orgCode'");
        print("🔍 Extracted token length: ${token.length}");
        print("🔍 Teams count: ${teams.length}");

        // Check for missing required fields
        if (userId.isEmpty) {
          print("❌ ERROR: User ID is empty");
          _showError("Server response missing: User ID");
          return;
        }

        if (orgId.isEmpty) {
          print("❌ ERROR: Organization ID is empty");
          _showError("Server response missing: Organization ID");
          return;
        }

        if (token.isEmpty) {
          print("❌ ERROR: Token is empty");
          _showError("Server response missing: Authentication Token");
          return;
        }

        // All required fields present
        print("✅ All required fields present. Saving to secure storage...");

        // Save to secure storage
        await _secureStorage.write(key: "userid", value: userId);
        await _secureStorage.write(key: "orgid", value: orgId);
        await _secureStorage.write(key: "orgCode", value: orgCode);
        await _secureStorage.write(key: "token", value: token);
        if (displayHeadingData != null) {
  await _secureStorage.write(
    key: "displayHeading",
    value: jsonEncode(displayHeadingData),
  );
  print("💾 Display heading saved to secure storage");
} else {
  print("⚠️ No display heading data found in response");
}



        print("💾 Saved to secure storage:");
        print("   - userid: $userId");
        print("   - orgid: $orgId");
        print("   - orgCode: $orgCode");
        print(
          "   - token: ${token.substring(0, token.length > 20 ? 20 : token.length)}...",
        );

        // Navigate to FinalHomePage
        if (mounted) {
          print("🚀 Navigating to FinalHomePage...");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => FinalHomePage(
                    userid: userId,
                    orgid: orgId,
                    orgCode: orgCode,
                    teams: teams,
                    loginData: jsonResponse,
                    token: token,
                     badapatradata: badapatradata,
                     displayHeading: displayHeadingData,
                      gallery: gallery, 
                   
                  ),
            ),
          );
        }
      } else {
        // Status is not "success"
        final errorMessage = jsonResponse["message"] ?? "Login failed.";
        print("❌ Login failed: $errorMessage");
        _showError(errorMessage);
      }
    } catch (e, stackTrace) {
      print("❌ Login error: $e");
      print("📚 Stack trace: $stackTrace");
      _showError("Network error. Please check your connection and try again.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/flag1.gif', height: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'नागरिक वडापत्र',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username | Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter username or email"
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed:
                            () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                      ),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Enter password"
                                : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                "Login",
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tech Support: +977-9707379820',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}