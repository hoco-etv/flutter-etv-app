import 'package:flutter/material.dart';
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
  bool _loggingOut = false;
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
      .showSnackBar(const SnackBar(content: Text('login failed :(')));
    }
  }

  logout() async
  {
    if (!_loggedIn) return;
    _loggingOut = true;

    await resetAuthState();

    setState(() {
      userProfile = null;
      _loggedIn = false;
    });

    ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar(content: Text('You have been logged out')));

    await Future.delayed(
      const Duration(milliseconds: 1495),
      () {
        _loggingOut = false;
      }
    );
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
  Widget build(BuildContext context)
  {
    if (!_loggingOut) {
      getUser().then((u) {
        if (u != null) {
          setState(() {
            userProfile = u;
            _loggedIn = true;
          });

          etv.fetchProfile()
          .then((p) {
            if (_disposed) return;
            setState(() { userProfile = p; });
          });
        }
      });
    }

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
                    child: Image.asset('assets/etv_shield.png'),
                  ),

                  const SizedBox(height: outerPaddingSize),

                  TextFormField(
                    autofillHints: const [
                      AutofillHints.email,
                      AutofillHints.username,
                    ],
                    onChanged: (newValue) {
                      username = newValue;
                    },
                    decoration: const InputDecoration(labelText: 'e-mail'),
                  ),

                  const SizedBox(height: outerPaddingSize),

                  TextFormField(
                    autofillHints: const [
                      AutofillHints.password,
                    ],
                    onChanged: (newValue) {
                      password = newValue;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'wachtwoord'),
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
                        Icon(Icons.send),
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
                          Icon(Icons.logout),
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
