import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_app/utils/widgets/textfield.dart';
import 'package:flash_chat_app/views/chat_screen.dart';
import 'package:flash_chat_app/views/login_scree.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'register_screen';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool spin = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: InkWell(
      //       onTap: () => Navigator.pop(context),
      //       child: const Icon(
      //         Icons.arrow_back,
      //         color: Colors.deepOrange,
      //       )),
      // ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: spin,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: height * 0.3,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'img/login.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.2,
                  width: width,
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 60, color: Colors.black),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText('Welcome',
                              speed: const Duration(milliseconds: 200))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.03),
                  width: width,
                  child: Column(
                    children: [
                      Mytextform(
                          controller: emailController,
                          iconData: const Icon(Icons.email_outlined),
                          hint: 'Email',
                          label: 'Email'),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Mytextform(
                          controller: passwordController,
                          obscure: true,
                          iconData: const Icon(Icons.password_outlined),
                          hint: 'Password',
                          label: 'Password'),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            spin = true;
                          });
                          try {
                            await auth.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                            print('Succefully logged in');
                            Navigator.pushNamed(context, ChatScreen.id);
                            setState(() {
                              spin = false;
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          width: width,
                          height: 50,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                                image: AssetImage("img/loginbtn.png"),
                                fit: BoxFit.cover),
                          ),
                          child: const Center(
                            child: Text(
                              "SignUp",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: width,
                        height: 50,
                        margin: const EdgeInsets.only(top: 60),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                                text: "Already have an account? ",
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                            context, LoginScreen.id),
                                      //..onTap creates an object. This is shortcut method

                                      text: "login",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange))
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
