import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_app/utils/widgets/textfield.dart';
import 'package:flash_chat_app/views/chat_screen.dart';
import 'package:flash_chat_app/views/registration_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  late AnimationController controller;
  late Animation animation;
  bool spin = false;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
    controller.forward();
    //animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    //animation = StepTween(begin: 0, end: 8).animate(controller);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: animation.value,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: spin,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: height * 0.5,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'img/login.png',
                      fit: BoxFit.cover,
                      height: 300 * controller.value,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
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
                            await auth.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
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
                              "Login",
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
                                text: "Don't have an account? ",
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                            context, RegistrationScreen.id),
                                      //..onTap creates an object. This is shortcut method

                                      text: "Create",
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
