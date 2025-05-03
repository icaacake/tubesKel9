import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Register",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                const Text("Create an account to get started",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text("Already have an account? Sign in",
                      style: TextStyle(color: Colors.cyan)),
                ),
                const SizedBox(height: 24),
                _buildNameFields(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 24),
                _buildRegisterButton(),
                const SizedBox(height: 24),
                _buildDivider(),
                const SizedBox(height: 16),
                _buildSocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(hintText: "First Name"),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your first name';
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(hintText: "Last Name"),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your last name';
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: "Email"),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your email';
        if (!value.contains('@')) return 'Please enter a valid email';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "Password",
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.white54,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter a password';
        if (value.length < 6) return 'Password too short';
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _handleRegister,
      child: const Text("Create Account", style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white54)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: const Text("Or register with", style: TextStyle(color: Colors.white54)),
        ),
        const Expanded(child: Divider(color: Colors.white54)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(Icons.g_mobiledata, () {}),
        const SizedBox(width: 16),
        _buildSocialButton(Icons.apple, () {}),
        const SizedBox(width: 16),
        _buildSocialButton(Icons.phone_iphone, () {}),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: Colors.grey[900],
      radius: 24,
      child: IconButton(
        icon: Icon(icon, size: 28, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.cyan, size: 60),
              const SizedBox(height: 16),
              const Text("Registration Successful!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
