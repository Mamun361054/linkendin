import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkendin/services/firebase_data_service.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import '../../widget/loading.dart';

class UserSignUp extends StatefulWidget {

  final Function toggleView;

  UserSignUp({required this.toggleView});

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {

  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  bool obscuredText = true;
  final AuthService _auth = AuthService();
  int selectedType = 0;

  //for password obscured text
  _toggle(){
    setState(() {
      obscuredText = !obscuredText;
    });
  }

  @override
  Widget build(BuildContext context) {

    final firebaseService = Provider.of<FirebaseDataService>(context);

    return isLoading ? Loading() : Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          margin: const EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Registration Page',style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.blue),),
                const SizedBox(height: 40.0,),
                TextFormField(
                  validator: (val)=> val!.isEmpty ? 'enter name please' : null,
                  style: const TextStyle(color: Colors.black,fontSize: 16.0),
                  decoration: InputDecoration(
                    hintText: 'Mr. Smith',
                    labelText: 'username',
                    border: InputBorder.none,
                    fillColor: Colors.grey.withOpacity(0.3),
                    filled: true,
                  ),
                  onChanged: (val){
                    setState(() {
                      name = val;
                    });
                  },
                ),
                const SizedBox(height: 20.0,),
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
                const SizedBox(height: 20.0,),
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
                  onTap: () async{
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        isLoading = true;
                      });
                      dynamic result = await _auth.registrationWithEmailAndPassword(email, password);
                      if(result == null){
                        setState(() {
                          isLoading = false;
                        });
                      }else{
                        Map<String,dynamic> map = {
                          'uid':'${result.uid}',
                          'name':name.trim(),
                          'email':email.trim(),
                          'identity':result.uid.toString().substring(0,5),
                        };
                        firebaseService.createAndUpdateUserInfo(map:map,uid:result.uid);
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    color: Colors.blue,
                    child: const Center(child: Text('Sign up',style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                ),
                const SizedBox(height: 20.0,),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('already have account?'),
                      GestureDetector(
                        onTap: (){
                          widget.toggleView();
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: const Text('Sign in',style: TextStyle(fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
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
