
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:math' as math;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'final_homepage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//   bool _isLoading = false;
//   bool _isPasswordVisible = false;
//   bool _rememberMe = false;

//   late AnimationController _animController;
//   late Animation<double> _fadeIn;
//   late Animation<Offset> _slideUp;

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedCredentials();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
//     _slideUp = Tween<Offset>(
//       begin: const Offset(0, 0.18),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
//     _animController.forward();
//   }



//   @override
//   void dispose() {
//     _animController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }


// Future<void> _loadSavedCredentials() async {
//   final prefs = await SharedPreferences.getInstance();
//   final remember = prefs.getBool('remember_me') ?? false;
//   if (remember) {
//     setState(() {
//       _rememberMe = true;
//       _usernameController.text = prefs.getString('saved_username') ?? '';
//       _passwordController.text = prefs.getString('saved_password') ?? '';
//     });
//   }
// }
//   void _showError(String message) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: const [
//             Icon(Icons.error_outline, color: Color(0xFFD32F2F)),
//             SizedBox(width: 8),
//             Text('Login Error', style: TextStyle(color: Color(0xFFD32F2F))),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK', style: TextStyle(color: Color(0xFF1565C0))),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _login() async {
//     if (!(_formKey.currentState?.validate() ?? false)) return;

//     setState(() => _isLoading = true);
//     final username = _usernameController.text.trim();
//     final password = _passwordController.text.trim();

//     try {
//       final url = Uri.parse("https://digitalbadapatra.com/api/v1/login");

//       print("🚀 Sending login request to: $url");
//       print("📧 Email: $username");

//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": username, "password": password}),
//       );

//       print("📡 Status Code: ${response.statusCode}");

//       if (response.statusCode != 200) {
//         _showError("Server error: ${response.statusCode}");
//         return;
//       }

//       final jsonResponse = jsonDecode(response.body);
//       print("✅ API RESPONSE STATUS: ${jsonResponse["status"]}");

//       if (jsonResponse["status"] == "success") {
//         print("👤 User Info: ${jsonResponse["user_info"]}");
//         print("🏢 Org Info: ${jsonResponse["organization_info"]}");

//         String userId = '';
//         if (jsonResponse["user_info"]?["userid"] != null) {
//           userId = jsonResponse["user_info"]["userid"].toString();
//         } else if (jsonResponse["user_info"]?["id"] != null) {
//           userId = jsonResponse["user_info"]["id"].toString();
//         }

//         final orgCode =
//             jsonResponse["organization_info"]?["org_code"]?.toString() ?? '';
//         final orgId = jsonResponse["user_info"]?["orgid"]?.toString() ?? '';
//         final badapatradata = jsonResponse["badapatradata"] ?? [];
//         final teams = jsonResponse["teams"] ?? [];
//         final token = jsonResponse["token"]?.toString() ?? '';
//         final displayHeadingData =
//             jsonResponse["badapatradata_display_heading"]
//                 as Map<String, dynamic>?;
//         final gallery = jsonResponse["gallery"] ?? [];

//         print("📊 Display Heading Data: $displayHeadingData");
//         print("🔍 Extracted userId: '$userId'");
//         print("🔍 Extracted orgCode: '$orgCode'");
//         print("🔍 Extracted token length: ${token.length}");
//         print("🔍 Teams count: ${teams.length}");

//         if (userId.isEmpty) {
//           _showError("Server response missing: User ID");
//           return;
//         }
//         if (orgId.isEmpty) {
//           _showError("Server response missing: Organization ID");
//           return;
//         }
//         if (token.isEmpty) {
//           _showError("Server response missing: Authentication Token");
//           return;
//         }

//         await _secureStorage.write(key: "userid", value: userId);
//         await _secureStorage.write(key: "orgid", value: orgId);
//         await _secureStorage.write(key: "orgCode", value: orgCode);
//         await _secureStorage.write(key: "token", value: token);



//         // Save or clear credentials based on remember me
// final prefs = await SharedPreferences.getInstance();
// if (_rememberMe) {
//   await prefs.setBool('remember_me', true);
//   await prefs.setString('saved_username', username);
//   await prefs.setString('saved_password', password);
// } else {
//   await prefs.setBool('remember_me', false);
//   await prefs.remove('saved_username');
//   await prefs.remove('saved_password');
// }
//         if (displayHeadingData != null) {
//           await _secureStorage.write(
//             key: "displayHeading",
//             value: jsonEncode(displayHeadingData),
//           );
//         }

//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => FinalHomePage(
//                 userid: userId,
//                 orgid: orgId,
//                 orgCode: orgCode,
//                 teams: teams,
//                 loginData: jsonResponse,
//                 token: token,
//                 badapatradata: badapatradata,
//                 displayHeading: displayHeadingData,
//                 gallery: gallery,
//               ),
//             ),
//           );
//         }
//       } else {
//         final errorMessage = jsonResponse["message"] ?? "Login failed.";
//         _showError(errorMessage);
//       }
//     } catch (e, stackTrace) {
//       print("❌ Login error: $e");
//       print("📚 Stack trace: $stackTrace");
//       _showError("Network error. Please check your connection and try again.");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             width: size.width,
//             height: size.height,
//             color: Colors.white,
//           ),

          
//           Positioned(
//             top: -60,
//             right: -60,
//             child: _circle(180, const Color(0xFFEEEEEE)),
//           ),
//           Positioned(
//             top: 60,
//             right: -30,
//            child: _circle(100, const Color(0xFFF5F5F5)),
//           ),
//           Positioned(
//             bottom: -80,
//             left: -50,
//            child: _circle(220, const Color(0xFFEEEEEE)),
//           ),
//           Positioned(
//             bottom: 80,
//             right: 20,
//               child: _circle(60, const Color(0xFFF0F0F0)),
//           ),

         
//           SafeArea(
//             child: Center(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 28, vertical: 24),
//                 child: FadeTransition(
//                   opacity: _fadeIn,
//                   child: SlideTransition(
//                     position: _slideUp,
//                     // child: Column(
//                     //   mainAxisAlignment: MainAxisAlignment.center,
//                     //   children: [

//                     child: Center(
//   child: ConstrainedBox(
//     constraints: const BoxConstraints(maxWidth: 480),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
                       
// const Text(
//   'नागरिक बडापत्र',
//   style: TextStyle(
//     fontSize: 26,
//     fontWeight: FontWeight.w800,
//     color: Color(0xFFCC0000),
//     letterSpacing: 0.5,
//   ),
// ),

// const SizedBox(height: 18),


// Container(
//   width: 110,
//   height: 110,
//   decoration: BoxDecoration(
//     shape: BoxShape.circle,
//     color: Colors.white,
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.25),
//         blurRadius: 20,
//         spreadRadius: 2,
//         offset: const Offset(0, 6),
//       ),
//     ],
//   ),
//   child: ClipOval(
//     child: Padding(
//       padding: const EdgeInsets.all(10),
//       child: Image.asset(
//         'assets/flag1.gif',
//         fit: BoxFit.contain,
//       ),
//     ),
//   ),
// ),

                      

//                         const SizedBox(height: 30),

                      
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(24),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.18),
//                                 blurRadius: 30,
//                                 spreadRadius: 0,
//                                 offset: const Offset(0, 10),
//                               ),
//                             ],
//                           ),
//                           padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
//                           child: Form(
//                             key: _formKey,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.stretch,
//                               children: [
//                                 // Welcome heading
//                                 const Text(
//                                   'Welcome Back 👋',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF0D3B8E),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 const Text(
//                                   'Please sign in to continue',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.grey,
//                                   ),
//                                 ),

//                                 const SizedBox(height: 26),

                                
//                                 _buildLabel('Username / Email'),
//                                 const SizedBox(height: 6),
//                                 TextFormField(
//                                   controller: _usernameController,
//                                   keyboardType: TextInputType.emailAddress,
//                                   style: const TextStyle(fontSize: 14),
//                                   decoration: _inputDecoration(
//                                    hint: 'Enter your username or email',
//                                     icon: Icons.person_outline_rounded,
//                                   ),
//                                   validator: (value) =>
//                                       value == null || value.isEmpty
//                                           ? "Please enter username or email"
//                                           : null,
//                                 ),

//                                 const SizedBox(height: 18),

                              
//                                 _buildLabel('Password'),
//                                 const SizedBox(height: 6),
//                                 TextFormField(
//                                   controller: _passwordController,
//                                   obscureText: !_isPasswordVisible,
//                                   style: const TextStyle(fontSize: 14),
//                                   decoration: _inputDecoration(
//                                     hint: 'Enter your password',
//                                     icon: Icons.lock_outline_rounded,
//                                     suffix: IconButton(
//                                       icon: Icon(
//                                         _isPasswordVisible
//                                             ? Icons.visibility_rounded
//                                             : Icons.visibility_off_rounded,
//                                        // color: Colors.grey,
//                                         color: const Color(0xFF1565C0),
//                                         size: 20,
//                                       ),
//                                       onPressed: () => setState(
//                                         () => _isPasswordVisible =
//                                             !_isPasswordVisible,
//                                       ),
//                                     ),
//                                   ),
//                                   validator: (value) =>
//                                       value == null || value.isEmpty
//                                           ? "Please enter password"
//                                           : null,
//                                 ),

//                                 const SizedBox(height: 5),

                               
// Row(
//   children: [
//     Checkbox(
//       value: _rememberMe,
//       activeColor: const Color(0xFF1565C0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(4),
//       ),
//       onChanged: (value) {
//         setState(() => _rememberMe = value ?? false);
//       },
//     ),
//     const Text(
//       'Remember Me',
//       style: TextStyle(
//         fontSize: 13,
//         color: Color(0xFF374151),
//         fontWeight: FontWeight.w500,
//       ),
//     ),
//   ],
// ),

                              
//                                 SizedBox(
//                                   height: 52,
//                                   child: ElevatedButton(
//                                     onPressed: _isLoading ? null : _login,
//                                     style: ElevatedButton.styleFrom(
//                                       padding: EdgeInsets.zero,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(14),
//                                       ),
//                                       elevation: 0,
//                                     ),
//                                     child: Ink(
//                                       decoration: BoxDecoration(
//                                         gradient: _isLoading
//                                             ? null
//                                             : const LinearGradient(
//                                                 colors: [
//                                                   Color(0xFF1565C0),
//                                                   Color(0xFF26A0DA),
//                                                 ],
//                                               ),
//                                         color: _isLoading
//                                             ? Colors.grey[300]
//                                             : null,
//                                         borderRadius:
//                                             BorderRadius.circular(14),
//                                       ),
//                                       child: Container(
//                                         alignment: Alignment.center,
//                                         child: _isLoading
//                                             ? const SizedBox(
//                                                 width: 24,
//                                                 height: 24,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                   color: Colors.white,
//                                                   strokeWidth: 2.5,
//                                                 ),
//                                               )
//                                             : const Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Text(
//                                                     'LOGIN',
//                                                     style: TextStyle(
//                                                       fontSize: 15,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       color: Colors.white,
//                                                       letterSpacing: 1.5,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 28),

                        
//                         const SizedBox(height: 14),

                        

//                         const SizedBox(height: 16),
//                       ],
//                     ),
//                   ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  

//   Widget _circle(double size, Color color) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(shape: BoxShape.circle, color: color),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.w600,
//         color: Color(0xFF374151),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration({
//     required String hint,
//     required IconData icon,
//     Widget? suffix,
//   }) {
//     return InputDecoration(
    
//       prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
//       suffixIcon: suffix,
//       filled: true,
//       fillColor: const Color(0xFFF5F7FA),
//       contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.2),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.8),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.2),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.8),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'final_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _rememberMe = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
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

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('remember_me') ?? false;
    if (remember) {
      setState(() {
        _rememberMe = true;
        _usernameController.text = prefs.getString('saved_username') ?? '';
        _passwordController.text = prefs.getString('saved_password') ?? '';
      });
    }
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

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": username, "password": password}),
      );

      if (response.statusCode != 200) {
        _showError("Server error: ${response.statusCode}");
        return;
      }

      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse["status"] == "success") {
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

        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setBool('remember_me', true);
          await prefs.setString('saved_username', username);
          await prefs.setString('saved_password', password);
        } else {
          await prefs.setBool('remember_me', false);
          await prefs.remove('saved_username');
          await prefs.remove('saved_password');
        }

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

    // ── TV / large-screen detection 
    final bool isTV = size.width >= 900;
    final double maxCardWidth = isTV ? 620.0 : 480.0;
    final double logoSize     = isTV ? 140.0  : 110.0;
    final double titleFont    = isTV ? 32.0   : 26.0;
    final double welcomeFont  = isTV ? 24.0   : 20.0;
    final double subFont      = isTV ? 15.0   : 13.0;
    final double labelFont    = isTV ? 15.0   : 13.0;
    final double inputFont    = isTV ? 16.0   : 14.0;
    final double inputVPad    = isTV ? 20.0   : 15.0;
    final double cardPadH     = isTV ? 40.0   : 24.0;
   // final double cardPadV     = isTV ? 42.0   : 30.0;
   final double cardPadV = isTV ? 28.0 : 20.0;
    final double buttonHeight = isTV ? 64.0   : 52.0;
    final double buttonFont   = isTV ? 17.0   : 15.0;
    final double iconSize     = isTV ? 24.0   : 20.0;
    

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(width: size.width, height: size.height, color: Colors.white),

          // Decorative circles
          Positioned(top: -60,   right: -60, child: _circle(180, const Color(0xFFEEEEEE))),
          Positioned(top: 60,    right: -30, child: _circle(100, const Color(0xFFF5F5F5))),
          Positioned(bottom: -80, left: -50, child: _circle(220, const Color(0xFFEEEEEE))),
          Positioned(bottom: 80,  right: 20, child: _circle(60,  const Color(0xFFF0F0F0))),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
              horizontal: isTV ? 80 : 28,
              vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: size.height -
                        MediaQuery.of(context).padding.top -
                        48,
                  ),
                  child: IntrinsicHeight(
                    child: FadeTransition(

                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxCardWidth),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            // ── Title
                            Text(
                              'नागरिक बडापत्र',
                              style: TextStyle(
                                fontSize: titleFont,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFCC0000),
                                letterSpacing: 0.5,
                              ),
                            ),

                           // SizedBox(height: isTV ? 24 : 18),
                           SizedBox(height: isTV ? 6 : 4),

                            // ── Logo
                            Container(
                              width: logoSize,
                              height: logoSize,
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

                           // SizedBox(height: isTV ? 36 : 30),
                             SizedBox(height: isTV ? 18 : 14),
                            // ── Card ─────────────────────────────────────
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
                              padding: EdgeInsets.fromLTRB(
                                  cardPadH, cardPadV, cardPadH, cardPadV - 6),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [

                                    // Welcome heading
                                    Text(
                                      'Welcome Back 👋',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: welcomeFont,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0D3B8E),
                                      ),
                                    ),
                                   const SizedBox(height: 2),
                                    Text(
                                      'Please sign in to continue',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: subFont,
                                        color: Colors.grey,
                                      ),
                                    ),

                                   
                                   SizedBox(height: isTV ? 20 : 16),

                                    // Username field
                                    _buildLabel('Username / Email', labelFont),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _usernameController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(fontSize: inputFont),
                                      decoration: _inputDecoration(
                                        hint: 'Enter your username or email',
                                        icon: Icons.person_outline_rounded,
                                        iconSize: iconSize,
                                        vPad: inputVPad,
                                      ),
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? "Please enter username or email"
                                              : null,
                                    ),

                                   // SizedBox(height: isTV ? 22 : 18),
                                   SizedBox(height: isTV ? 14 : 12),

                                    // Password field
                                    _buildLabel('Password', labelFont),
                                   // const SizedBox(height: 6),

                                  const SizedBox(height: 4),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: !_isPasswordVisible,
                                      style: TextStyle(fontSize: inputFont),
                                      decoration: _inputDecoration(
                                        hint: 'Enter your password',
                                        icon: Icons.lock_outline_rounded,
                                        iconSize: iconSize,
                                        vPad: inputVPad,
                                        suffix: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded,
                                            color: const Color(0xFF1565C0),
                                            size: iconSize,
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

                                 //   const SizedBox(height: 5),
                                 const SizedBox(height: 3),

                                    // Remember Me
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          activeColor: const Color(0xFF1565C0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          onChanged: (value) {
                                            setState(() =>
                                                _rememberMe = value ?? false);
                                          },
                                        ),
                                        Text(
                                          'Remember Me',
                                          style: TextStyle(
                                            fontSize: labelFont,
                                            color: const Color(0xFF374151),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),

                                //    SizedBox(height: isTV ? 8 : 4),
                                SizedBox(height: isTV ? 4 : 2),

                                    // Login button
                                    SizedBox(
                                      height: buttonHeight,
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
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'LOGIN',
                                                        style: TextStyle(
                                                          fontSize: buttonFont,
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

                            SizedBox(height: isTV ? 36 : 28),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ), // IntrinsicHeight
                ), // ConstrainedBox
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

  Widget _buildLabel(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF374151),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required double iconSize,
    required double vPad,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: iconSize),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      contentPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: vPad),
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