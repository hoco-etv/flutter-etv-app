# ETV app
Another attempt at building a nice ETV app. This app uses the API of the ETV website to access data from the site.

## Development
This app is built using Dart and the Flutter UI framework. Because of the architecture of Flutter, one can build an app almost completely in Dart and then compile it for all the available platforms (Android, iOS, Windows, web).

### VSCode extensions you should have
First of all, you should have the [Flutter extension]. Aside from IntelliSense for Flutter & Dart it also has some utilities e.g. for selecting a device to run/debug on.

Also, if you have a hard time keeping your code clean, you might like [Trailing Spaces].

[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
[Trailing Spaces]: https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces

### Setting up the project
1. Clone this repository
2. Inside the repository, run:  
`flutter pub get`  
`flutter pub run flutter_native_splash:create`

### Android dev environment setup
1. [Install the flutter SDK](https://docs.flutter.dev/get-started/install)
2. a. install an Android emulator (via the AVD Manager in the Android SDK)  
   b. connect an Android phone with USB debugging enabled via a USB cable

#### Running and building
Once everything is set up and connected, `flutter run` will build the app in debug mode and run it on the selected device.

For building I recommend you read the [manual][build manual]. My workflow for Android (with my phone connected via USB) is pretty easy:

1. `flutter build apk`
2. `flutter install`

This will build & install a release package on your phone. For doing actual production releases it might be useful to look into [app bundles] for their reduced size.

### iOS dev environment setup
No idea, this is a `//TODO`.

## Feature wish list
- [x] Login mechanism
- [x] Digideb
- [x] Upcoming activities
  - [ ] Better view on the activities page
- [x] Cool splash screen
- [x] Notification for new activities
  - [x] Periodic background fetching
  - [ ] Notification bubble
  - [ ] Toggle for notifications
- [ ] Koffietimer connection
- [x] Ledensearch
- [x] More profile info
- [ ] Quotes
  - [ ] Quote submissions
- [ ] Maxwell browser
- [ ] Exam browser
- [ ] Education help wizard
- [ ] Anti-SOG memes
- [ ] ETV netpresenter content
- [ ] General assembly stuff
  - [ ] Integration with [semicolon] GA module
  - [ ] Browser for minutes of previous GA's

[build manual]: https://docs.flutter.dev/deployment/android#building-the-app-for-release
[app bundles]: https://docs.flutter.dev/deployment/android#when-should-i-build-app-bundles-versus-apks
[semicolon]: https://github.com/hoco-etv/semicolon

## Dependencies & resources
* [ETV Semicolon][semicolon]
* [Hive document store](https://pub.dev/packages/hive)
* [HTML display library](https://pub.dev/packages/flutter_widget_from_html)
* [Splash screen generator](https://pub.dev/packages/flutter_native_splash)
* [Icon bundle](https://pub.dev/packages/flutter_font_icons) (currently only using [Feather icons](https://feathericons.com))

### Dart in short
Dart is a strongly typed language, not unlike Java or C#. In many ways I have found it to closely resemble TypeScript in its functionality, with a few notable differences. Firstly, simple objects as such do not exist; instead Dart has Maps, Classes and Enums. Parameters for widgets and functions are almost always a primitive type or typed with a class instance or an enum, so instead of `f({ axis: 'horizontal' })` you would input `f( axis: Axis.horizontal )`. This ensures the correct input type for `f` at compile time.
Another notable difference is that aside from usual positional parameters, Dart also has named parameters as demonstrated in the last example.

### Widgets
Everything in Flutter is a Widget; a component, making building modular applications relatively easy. By far most widgets are either a `StatelessWidget` or a `StatefulWidget`. `StatelessWidgets` are constructed once and do not maintain an internal state, so their display state is either constant or directly dependent on the input parameters. `StatefulWidgets` have an internal state and some functionality to make sure the widget gets updated when the state changes.

When a dependency of a widget changes, the widget is entirely rebuilt/redrawn. Apparently this is faster than modifying a small part of it, but it is also a major difference with many web UI libraries.
