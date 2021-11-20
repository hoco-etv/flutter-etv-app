import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:etv_app/store/user.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/widgets/switcher.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/utils/etv_api_client.dart' as etv;

class ProfilePage extends StatefulWidget {
  const ProfilePage([Key? key]) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? userProfile;

  bool _loggedIn = false;
  bool _loginFailedState = false;
  bool _disposed = false;

  String username = '';
  String password = '';

  login() async
  {
    if (_loggedIn) return;

    final result = await etv.login(username, password);
    if (result.runtimeType == UserProfile) {
      setState(() {
        userProfile = result;
        _loggedIn = true;
        _loginFailedState = false;
      });
    }
    else {
      setState(() {
        _loginFailedState = true;
      });

      ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Inloggen mislukt :(')));
    }
  }

  logout() async
  {
    if (!_loggedIn) return;

    await resetAuthState();

    setState(() {
      userProfile = null;
      _loggedIn = false;
    });

    ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar(content: Text('Je bent uitgelogd')));
  }

  Color get _balanceColor
  {
    return userProfile?.balance != null && userProfile!.balance! > 0 ? etvRed.shade200 : barelyBlack;
  }

  String get _balanceText
  {
    return userProfile?.balance != null && userProfile!.balance! > 0
      ? 'Kom hem eens een keer aanvullen bij de balie en maak de Thesau heel blij :)'
      : 'Goed bezig ;)';
  }

  @override
  initState()
  {
    super.initState();

    getUser().then((u) {
      if (u != null) {
        setState(() {
          userProfile = u;
          _loggedIn = true;
        });

        etv.fetchProfile()
        .then((p) {
          if (_disposed) return;
          if (p == null) {
            logout();
            return;
          }
          setState(() { userProfile = p; });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return DefaultLayout(
      title: _loggedIn ? 'Profiel' : 'Log in',
      pageContent: Switcher(
        condition: _loggedIn,

        /* *** LOGIN PAGE *** */
        childIfFalse: Container(
          padding: outerPadding,
          alignment: Alignment.center,

          child: Card(
            child: Container(
              padding: outerPadding,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  FractionallySizedBox(
                    widthFactor: 1/4,
                    child: Image.asset('assets/etv_schild.png'),
                  ),

                  SizedBox(height: !_loginFailedState ? outerPaddingSize : innerPaddingSize),

                  Visibility(
                    visible: _loginFailedState,
                    child: const Text(
                      'Ongeldige inloggegevens',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                  const SizedBox(height: innerPaddingSize),

                  AutofillGroup(
                    child: Column(children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'e-mail'),
                        autofillHints: const [ AutofillHints.username ],
                        onChanged: (newValue) { username = newValue; },
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: outerPaddingSize),

                      TextFormField(
                        decoration: const InputDecoration(labelText: 'wachtwoord'),
                        autofillHints: const [ AutofillHints.password ],
                        obscureText: true,
                        onChanged: (newValue) { password = newValue; },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_value) { login(); },
                      ),
                    ]),
                  ),

                  const SizedBox(height: outerPaddingSize),

                  ElevatedButton(
                    onPressed: login,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Log in',
                          textScaleFactor: 1.5,
                        ),
                        Icon(Ionicons.log_in_outline),
                      ],
                    ),
                  ),
                ]
              ),
            )

          ),
        ),


        /* *** PROFILE *** */
        childIfTrue: Container(
          padding: outerPadding,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Visibility(
                visible: userProfile?.balance != null,

                child: Card(child: Container(
                  padding: outerPadding*1.5,

                  child: Column(
                    children: [
                      Text(
                        'Je huidige debstand is',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: outerPaddingSize),
                      Text(
                        '€ -${userProfile?.balance?.toStringAsFixed(2).replaceFirst('.', ',') ?? '[bedrag?]'}',
                        style: Theme.of(context).textTheme.headline2?.merge(
                          TextStyle(color: _balanceColor),
                        ),
                      ),

                      const SizedBox(height: outerPaddingSize),

                      Text(
                        _balanceText
                      )
                    ],
                  ),
                )),
              ),

              const SizedBox(height: outerPaddingSize),

              Card(child: Container(
                padding: outerPadding,

                child: Column(
                  children: [
                    Text(
                      userProfile?.name ?? '[naam?]',
                      style: Theme.of(context).textTheme.headline5,
                    ),

                    const SizedBox(height: outerPaddingSize),

                    ElevatedButton(
                      onPressed: logout,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Log uit',
                            textScaleFactor: 1.5,
                          ),
                          Icon(Ionicons.log_out_outline),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          )
        ),
      ),
    );
  }

  @override
  dispose()
  {
    _disposed = true;
    super.dispose();
  }
}
