
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'final_homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.error_outline, color: Color(0xFFD32F2F)),
            SizedBox(width: 8),
            Text('Login Error', style: TextStyle(color: Color(0xFFD32F2F))),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFF1565C0))),
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

      final jsonResponse = jsonDecode(response.body);
      print("✅ API RESPONSE STATUS: ${jsonResponse["status"]}");

      if (jsonResponse["status"] == "success") {
        print("👤 User Info: ${jsonResponse["user_info"]}");
        print("🏢 Org Info: ${jsonResponse["organization_info"]}");

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
        final displayHeadingData =
            jsonResponse["badapatradata_display_heading"]
                as Map<String, dynamic>?;
        final gallery = jsonResponse["gallery"] ?? [];

        print("📊 Display Heading Data: $displayHeadingData");
        print("🔍 Extracted userId: '$userId'");
        print("🔍 Extracted orgCode: '$orgCode'");
        print("🔍 Extracted token length: ${token.length}");
        print("🔍 Teams count: ${teams.length}");

        if (userId.isEmpty) {
          _showError("Server response missing: User ID");
          return;
        }
        if (orgId.isEmpty) {
          _showError("Server response missing: Organization ID");
          return;
        }
        if (token.isEmpty) {
          _showError("Server response missing: Authentication Token");
          return;
        }

        await _secureStorage.write(key: "userid", value: userId);
        await _secureStorage.write(key: "orgid", value: orgId);
        await _secureStorage.write(key: "orgCode", value: orgCode);
        await _secureStorage.write(key: "token", value: token);
        if (displayHeadingData != null) {
          await _secureStorage.write(
            key: "displayHeading",
            value: jsonEncode(displayHeadingData),
          );
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => FinalHomePage(
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
        final errorMessage = jsonResponse["message"] ?? "Login failed.";
        _showError(errorMessage);
      }
    } catch (e, stackTrace) {
      print("❌ Login error: $e");
      print("📚 Stack trace: $stackTrace");
      _showError("Network error. Please check your connection and try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            color: Colors.white,
          ),

          
          Positioned(
            top: -60,
            right: -60,
            child: _circle(180, const Color(0xFFEEEEEE)),
          ),
          Positioned(
            top: 60,
            right: -30,
           child: _circle(100, const Color(0xFFF5F5F5)),
          ),
          Positioned(
            bottom: -80,
            left: -50,
           child: _circle(220, const Color(0xFFEEEEEE)),
          ),
          Positioned(
            bottom: 80,
            right: 20,
              child: _circle(60, const Color(0xFFF0F0F0)),
          ),

         
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 24),
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
const Text(
  'नागरिक बडापत्र',
  style: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Color(0xFFCC0000),
    letterSpacing: 0.5,
  ),
),

const SizedBox(height: 18),


Container(
  width: 110,
  height: 110,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 20,
        spreadRadius: 2,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: ClipOval(
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Image.asset(
        'assets/flag1.gif',
        fit: BoxFit.contain,
      ),
    ),
  ),
),

                      

                        const SizedBox(height: 30),

                      
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 30,
                                spreadRadius: 0,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Welcome heading
                                const Text(
                                  'Welcome Back 👋',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D3B8E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Please sign in to continue',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 26),

                                
                                _buildLabel('Username / Email'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _usernameController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: _inputDecoration(
                                   hint: 'Enter your username or email',
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? "Please enter username or email"
                                          : null,
                                ),

                                const SizedBox(height: 18),

                              
                                _buildLabel('Password'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: _inputDecoration(
                                    hint: 'Enter your password',
                                    icon: Icons.lock_outline_rounded,
                                    suffix: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                       // color: Colors.grey,
                                        color: const Color(0xFF1565C0),
                                        size: 20,
                                      ),
                                      onPressed: () => setState(
                                        () => _isPasswordVisible =
                                            !_isPasswordVisible,
                                      ),
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? "Please enter password"
                                          : null,
                                ),

                                const SizedBox(height: 28),

                              
                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _login,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        gradient: _isLoading
                                            ? null
                                            : const LinearGradient(
                                                colors: [
                                                  Color(0xFF1565C0),
                                                  Color(0xFF26A0DA),
                                                ],
                                              ),
                                        color: _isLoading
                                            ? Colors.grey[300]
                                            : null,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              )
                                            : const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'LOGIN',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 1.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        
                        const SizedBox(height: 14),

                        

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
    
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.8),
      ),
    );
  }
}




