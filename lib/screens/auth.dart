import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';




final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();


  var _isLogin = true;
  var _isAuthenticating = false;
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    try{
      setState(() {
        _isAuthenticating = true;
      });

      if(_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
        


      FirebaseFirestore.instance
      .collection('users')
      .doc(userCredentials.user!.uid)
      .set({
        'username': _enteredUsername,
        'email': _enteredEmail,
      });

      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
            //...
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
              error.message ?? 'Authentication failed.'),
          ),
          
        ); 
        setState(() {
          _isAuthenticating = false;
        });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 3, 15, 32),
              Color.fromARGB(255, 40, 93, 153),
              Color.fromARGB(255, 128, 175, 230),
            ]
            ),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         const Padding(
                          padding: EdgeInsets.only(top: 150)),
                           const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w300
                              ),
                            ),  
                            const SizedBox(height: 5,),
                          const Text(
                          'Welcome Back !',
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),         
                              ),                      
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
                                  child: Form(
                                    key: _form,
                                    child: Column(
                                      children: [
                                         TextFormField(      
                                            decoration: InputDecoration(
                                            labelText: 'Email',
                                            enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Color.fromARGB(255, 10, 35, 88))),),
                                            keyboardType: TextInputType.emailAddress,
                                            autocorrect: false,
                                            textCapitalization: TextCapitalization.none,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty ||
                                                  !value.contains('@')) {
                                                return 'Please enter a valid email address.';
                                              }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _enteredEmail = value!;    
                                               },    
                                              ),
                                              const SizedBox(height: 20),
                                              if (!_isLogin)
                                            TextFormField(
                                                decoration: InputDecoration(
                                                labelText: 'Username',
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(
                                                      color: Color.fromARGB(255, 10, 35, 88))),
                                                ),  
                                                validator: (value) {
                                                  if (value == null ||
                                                  value.isEmpty ||
                                                  value.trim().length < 4) {
                                                    return 'Please enter at least 4 characters.';
                                                  }
                                                  return null;
                                              },
                                              onSaved: (value) {
                                                _enteredUsername = value!;
                                              },          
                                              ),
                                              const SizedBox(height: 20),
                                            TextFormField(                                             
                                              decoration: InputDecoration(
                                                labelText: 'Password',
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Color.fromARGB(255, 10, 35, 88)
                                                ),
                                             ),
                                          ), 
                                          validator: (value) {
                                                if (
                                                    value == null ||
                                                    value.trim().length < 6) {
                                                    return 'Password must be at least 6 characters long.';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _enteredPassword = value!;
                                                },
                                       ), 
                               const SizedBox(height: 40,),
                               if (_isAuthenticating)
                                  const CircularProgressIndicator(),
                               if (!_isAuthenticating)
                               SizedBox( 
                                height: 50,
                                width: 250,
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 40, 93, 153)),
                                   child: Text(_isLogin
                                  ? 'Login'
                                  : 'Signup',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    ),
                                  ),
                                ),
                               ),
                               const SizedBox(height: 20,),
                               if (!_isAuthenticating)
                               TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an account',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 10, 35, 88),
                                   ),
                                  ),
                                ),
                             ],
                          ),                     
                        ),
                     ),
                   ),  
                 ),         
               ),
             ]
           ),
         ),
   );
  }
}

