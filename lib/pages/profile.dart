import 'dart:math';
import 'package:flutter/material.dart';
import 'package:etv_app/layouts/default.dart';
import 'package:etv_app/utils/etv_style.dart';
import 'package:etv_app/data_source/store.dart';
import 'package:etv_app/data_source/objects.dart';
import 'package:etv_app/data_source/api_client.dart' as etv;
import 'package:etv_app/widgets/profile_view.dart';
import 'package:etv_app/widgets/utils/switcher.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage([Key? key]) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? userProfile;

  bool _loggedIn = false;
  String? _loginFailedMessage;
  bool _loginRequestPending = false;
  bool _disposed = false;

  String username = '';
  String password = '';

  login() async
  {
    if (_loggedIn) return;

    if (username == '' || password == '') {
      setState(() {
        _loginFailedMessage = 'E-mail en wachtwoord zijn vereist';
      });
      return;
    }

    _loginRequestPending = true;

    final result = await etv.login(username, password);
    if (result.runtimeType == User) {
      setState(() {
        userProfile = result;
        _loggedIn = true;
        _loginFailedMessage = null;
        username = '';
        password = '';
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
    return userProfile?.person?.digidebBalance != null && userProfile!.person!.digidebBalance! > 0 ? etvRed.shade200 : barelyBlack;
  }

  String get _balanceText
  {
    return userProfile?.person?.digidebBalance != null && userProfile!.person!.digidebBalance! > 0
      ? 'Kom het eens een keer aanvullen bij de balie en maak de Thesau heel blij :)'
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
      pageContent: ListView(children: [
        Switcher(
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

                    SizedBox(height: _loginFailedMessage == null ? outerPaddingSize : innerPaddingSize),

                    Visibility(
                      visible: _loginFailedMessage != null,
                      child: Text(
                        _loginFailedMessage ?? '',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                    const SizedBox(height: innerPaddingSize),

                    AutofillGroup(
                      child: Column(children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'e-mail'),
                          onChanged: (newValue) { username = newValue; },
                          autofillHints: const [ AutofillHints.username ],
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                        ),

                        const SizedBox(height: outerPaddingSize),

                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'wachtwoord'),
                          onChanged: (newValue) { password = newValue; },
                          autofillHints: const [ AutofillHints.password ],
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_value) { login(); },
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
                // Text('Heading 1', style: Theme.of(context).textTheme.headline1),
                // Text('Heading 2', style: Theme.of(context).textTheme.headline2),
                // Text('Heading 3', style: Theme.of(context).textTheme.headline3),
                // Text('Heading 4', style: Theme.of(context).textTheme.headline4),
                // Text('Heading 5', style: Theme.of(context).textTheme.headline5),
                // Text('Heading 6', style: Theme.of(context).textTheme.headline6),
                // Text('Subtitle 1', style: Theme.of(context).textTheme.subtitle1),
                // Text('Subtitle 2', style: Theme.of(context).textTheme.subtitle2),
                // Text('Body text 1', style: Theme.of(context).textTheme.bodyText1),
                // Text('Body text 2', style: Theme.of(context).textTheme.bodyText2),
                // Text('Overline', style: Theme.of(context).textTheme.overline),

                Visibility(
                  visible: userProfile?.person?.digidebBalance != null,

                  child: Card(child: Container(
                    padding: outerPadding,

                    child: Column(
                      children: [
                        Text(
                          'ETVermogen',
                          style: Theme.of(context).textTheme.headline3,
                        ),

                        Text(
                          '€ -${userProfile?.person?.digidebBalance?.toStringAsFixed(2).replaceFirst('.', ',') ?? '[bedrag?]'}',
                          style: TextStyle(
                            fontSize: 32 + min(48, userProfile?.person?.digidebBalance ?? 0), // more deb = bigger font :)
                            fontWeight: FontWeight.w400,
                            color: _balanceColor,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: innerPaddingSize/2),

                        Text(
                          _balanceText,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )),
                ),

                const SizedBox(height: outerPaddingSize),

                Card(child: Container(
                  padding: outerPadding,

                  child: userProfile?.person != null ? ProfileView(userProfile!.person!) : Container(),
                )),

                const SizedBox(height: outerPaddingSize),

                Card(child: Container(
                  padding: outerPadding,

                  child: ElevatedButton(
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
                )),
              ],
            )
          ),
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
