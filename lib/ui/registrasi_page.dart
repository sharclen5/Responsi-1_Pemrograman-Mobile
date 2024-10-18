import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/bloc/registrasi_bloc.dart'; // Import your RegistrasiBloc
import 'login_page.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 245, 243, 115),
                  Color.fromARGB(255, 239, 241, 97),
                  Color.fromARGB(255, 224, 214, 71),
                  Color.fromARGB(255, 229, 226, 57),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 120.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Registrasi',
                  style: TextStyle(
                    color: Color.fromARGB(255, 243, 160, 5),
                    fontFamily: 'Helvetica',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _namaTextField(),
                      const SizedBox(height: 20.0),
                      _emailTextField(),
                      const SizedBox(height: 20.0),
                      _passwordTextField(),
                      const SizedBox(height: 20.0),
                      _passwordKonfirmasiTextField(),
                      const SizedBox(height: 30.0),
                      _buttonRegistrasi(), // Updated registration button
                    ],
                  ),
                ),
                _buildLoginBtn(),
              ],
            ),
          ),
          _isLoading ? const Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Nama',
        labelStyle: TextStyle(fontFamily: 'Helvetica'),
        prefixIcon: Icon(Icons.person),
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return 'Nama harus diisi minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(fontFamily: 'Helvetica'),
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return 'Email tidak valid';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(fontFamily: 'Helvetica'),
        prefixIcon: Icon(Icons.lock),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) {
          return 'Password harus diisi minimal 6 karakter';
        }
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Konfirmasi Password',
        labelStyle: TextStyle(fontFamily: 'Helvetica'),
        prefixIcon: Icon(Icons.lock),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return 'Konfirmasi Password tidak sama';
        }
        return null;
      },
    );
  }

  // Updated button with async registration logic
  Widget _buttonRegistrasi() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 166, 0),
      ),
      child: const Text(
        'Registrasi',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: 'Helvetica',
          color: Colors.black,
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });

          try {
            var registrasiResponse = await RegistrasiBloc.registrasi(
              nama: _namaTextboxController.text,
              email: _emailTextboxController.text,
              password: _passwordTextboxController.text,
            );

            // Show success message
            if (registrasiResponse.status == true) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Registration Success'),
                    content: const Text('You have successfully registered.'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registration failed: ${registrasiResponse.data}')),
              );
            }
          } catch (error) {
            // Handle API or other errors
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
    );
  }

  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Color.fromARGB(255, 243, 160, 5),
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Color.fromARGB(255, 133, 100, 8),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
