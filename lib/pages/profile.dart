import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/utils/feedback.dart';
import '/utils/etv_style.dart';
import '/layouts/default.dart';
import '/widgets/profile_view.dart';
import '/data_source/store.dart';
import '/data_source/objects.dart';
import '/data_source/api_client/endpoints.dart' as etv;

class ProfilePage extends StatefulWidget {
  const ProfilePage([Key? key]) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? userProfile;

  bool _loggedIn = false;
  bool _loginRequestPending = false;
  String? _loginFailedMessage;

  bool showPassword = false;

  bool _disposed = false;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  login() async
  {
    if (_loggedIn) return;

    if (username.text == '' || password.text == '') {
      setState(() {
        _loginFailedMessage = 'E-mail en wachtwoord zijn vereist';
      });
      return;
    }

    _loginRequestPending = true;

    final result = await etv.login(username.text.trim(), password.text);
    if (result.runtimeType == User) {
      setState(() {
        userProfile = result;
        _loggedIn = true;
        _loginFailedMessage = null;
        username.clear();
        password.clear();
      });
    }
    else {
      setState(() {
        _loginFailedMessage = 'Ongeldige inloggegevens';
      });
    }

    _loginRequestPending = false;
  }

  logout() async
  {
    if (!_loggedIn) return;

    ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar(content: Text('Je wordt uitgelogd')));

    await resetAuthState();

    setState(() {
      userProfile = null;
      _loggedIn = false;
    });
  }

  Color get _balanceColor
  {
    return userProfile?.person?.digidebBalance != null && userProfile!.person!.digidebBalance! > 0
      ? etvRed.shade200
      : Theme.of(context).colorScheme.onSurface;
  }

  String get _balanceText
  {
    return userProfile?.person?.digidebBalance != null && userProfile!.person!.digidebBalance! > 0
      ? 'Kom het eens een keer aanvullen bij de balie en maak de Thesau heel blij :)'
      : '';
  }

  @override
  initState()
  {
    super.initState();

    final u = getUser();
    if (u != null) {
      setState(() {
        userProfile = u;
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final feedbackWidget = feedbackText(
      context,
      textAlign: TextAlign.center,
      textScaleFactor: 1.2
    );

    return DefaultLayout(
      title: _loggedIn ? 'Profiel' : 'Log in',

      onRefresh: !_loggedIn ? null : () {
        return etv.fetchProfile()
        .then((p) {
          if (_disposed) return false;
          if (p == null) {
            logout();
            return false;
          }
          setState(() { userProfile = p; });
          return true;
        });
      },
      refreshOnLoad: true,

      pageContent: ListView(children: [

        /* *** LOGIN PAGE *** */
        if (!_loggedIn) Container(
          alignment: Alignment.center,

          child: Card(
            margin: outerPadding,

            child: Container(
              padding: outerPadding.copyWith(bottom: 0),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  FractionallySizedBox(
                    widthFactor: 1/4,
                    child: Image.asset('assets/etv_schild.png'),
                  ),

                  SizedBox(height: _loginFailedMessage == null ? outerPaddingSize : innerPaddingSize),

                  if (_loginFailedMessage != null)
                  Text(
                    _loginFailedMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                  const SizedBox(height: innerPaddingSize),

                  AutofillGroup(
                    child: Column(children: [
                      TextField(
                        controller: username,
                        decoration: const InputDecoration(labelText: 'e-mail'),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [ AutofillHints.email, AutofillHints.username ],
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),

                      const SizedBox(height: outerPaddingSize),

                      TextField(
                        controller: password,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'wachtwoord',
                          suffixIcon: IconButton(
                            onPressed: () => setState(() { showPassword = !showPassword; }),
                            icon: Icon(showPassword ? Feather.eye_off : Feather.eye),
                          ),
                        ),
                        onSubmitted: (value) { login(); },
                        keyboardType: TextInputType.visiblePassword,
                        autofillHints: const [ AutofillHints.password ],
                        textInputAction: TextInputAction.done,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ]),
                  ),

                  const SizedBox(height: outerPaddingSize),

                  ElevatedButton(
                    onPressed: !_loginRequestPending ? login : null,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Log in',
                          style: Theme.of(context).textTheme.button?.merge(const TextStyle(fontSize: 21)),
                        ),

                        Container(
                          padding: const EdgeInsets.only(bottom: 3),

                          child: Icon(
                            Feather.log_in,
                            size: (Theme.of(context).textTheme.button?.fontSize ?? 0)*2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ExpansionTile(
                    title: const Text('Feedback'),
                    tilePadding: const EdgeInsets.symmetric(horizontal: innerPaddingSize/4),
                    childrenPadding: const EdgeInsets.only(bottom: outerPaddingSize),
                    children: [
                      feedbackWidget,
                    ],
                  ),
                ]
              ),
            )

          ),
        ),


        /* *** PROFILE *** */
        if (_loggedIn) Container(
          margin: outerPadding,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              if (userProfile?.person?.digidebBalance != null) ...[
                Card(
                  child: Container(
                  padding: outerPadding.copyWith(top: innerPaddingSize),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'ETVermogen:',
                            style: Theme.of(context).textTheme.headline4?.merge(const TextStyle(fontFamily: 'RobotoSlab')),
                          ),

                          Text(
                            '€ ${(-userProfile!.person!.digidebBalance!).toStringAsFixed(2).replaceFirst('.', ',')}',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'RobotoSlab',
                              letterSpacing: 1.25,
                              fontWeight: FontWeight.w500,
                              color: _balanceColor,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),

                      if (userProfile!.person!.digidebBalance! > 0) ...[
                        const SizedBox(height: innerPaddingSize/2),

                        Text(
                          _balanceText,
                          style: Theme.of(context).textTheme.subtitle1,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ],
                  ),
                )),

                const SizedBox(height: outerPaddingSize),
              ],

              Card(child: Container(
                padding: outerPadding,

                child: userProfile?.person != null ? ProfileView(userProfile!.person!) : Container(),
              )),

              const SizedBox(height: outerPaddingSize),

              Card(child: Container(
                padding: outerPadding,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: logout,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Log uit',
                            style: Theme.of(context).textTheme.button?.merge(const TextStyle(fontSize: 21)),
                          ),

                          Container(
                            padding: const EdgeInsets.only(bottom: 3),

                            child: Icon(
                              Feather.log_out,
                              size: (Theme.of(context).textTheme.button?.fontSize ?? 0)*2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(
                        top: outerPaddingSize,
                        left: innerPaddingSize/2,
                        right: innerPaddingSize/2,
                      ),
                      child: feedbackWidget,
                    ),
                  ],
                ),
              )),
            ],
          )
        ),

        /* ** Debug stuff ** */
        if (kDebugMode) Card(
          margin: outerPadding.copyWith(top: 0),
          child: Container(
            padding: innerPadding,

            child: Table(children: [
              TableRow(children: [
                const Text('Token:'),
                SelectableText(
                  getToken().toString(),
                  style: const TextStyle(fontFamily: 'RobotoMono')
                ),
              ])
            ])
          )
        ),
      ]),
    );
  }

  @override
  dispose()
  {
    _disposed = true;
    super.dispose();
  }
}
