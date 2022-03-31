import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/auth.dart';
import '../../widget/loading.dart';

class UserSignIn extends StatefulWidget {

  final Function toggleView;

    UserSignIn({required this.toggleView});

  @override
  _UserSignInState createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  bool obscuredText = true;
  final AuthService _auth = AuthService();

  //for password obscured text
  _toggle(){
    setState(() {
      obscuredText = !obscuredText;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return isLoading ? Loading() : Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('WELCOME TO ',style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.blue),),
                Text('LOGIN PAGE',style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.black),),
                const SizedBox(height: 40.0,),
                TextFormField(
                  validator: (val)=> val!.isEmpty ? 'enter email please' : null,
                  style: const TextStyle(color: Colors.black,fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: 'a@b.com',
                    labelText: 'email',
                    border: InputBorder.none,
                    fillColor: Colors.grey.withOpacity(0.3),
                    filled: true,
                  ),
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                ),
                const SizedBox(height: 16.0,),
                TextFormField(
                  validator: (val)=> val!.isEmpty ? 'enter password please' : null,
                  style: const TextStyle(color: Colors.black,fontSize: 16.0),
                  obscureText: obscuredText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed: _toggle, icon :Icon(FontAwesomeIcons.eyeSlash, color: obscuredText ? Colors.black54 : Colors.black12)),
                    hintText: '****',
                    labelText: 'password',
                    border: InputBorder.none,
                    fillColor: Colors.grey.withOpacity(0.3),
                    filled: true,
                  ),
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
                GestureDetector(
                  onTap: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        isLoading = true;
                      });
                      dynamic result = await _auth.signinWithEmailAndPassword(email.trim(), password.trim());

                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    color: Colors.blue,
                    child: const Center(child: Text('Sign in',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Don`t have account?'),
                      GestureDetector(
                        onTap: (){
                          widget.toggleView();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: const Text('Register',style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
