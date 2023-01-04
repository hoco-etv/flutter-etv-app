import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/utils/etv_style.dart';

final emailUrl = Uri(
  scheme: 'mailto',
  path: 'HoCo-ETV@tudelft.nl',
  queryParameters: {
    'subject': '[HoCo] Suggestie voor de ETV-app',
    'body': 'Hoi HoCo,\n\nIk heb een suggestie voor / klacht over de ETV-app: \n\n'
  }
);
final githubNewIssueUrl = Uri(
  scheme: 'https',
  host: 'github.com',
  path: 'hoco-etv/flutter-etv-app/issues'
);

Widget feedbackText(context, {
  TextAlign textAlign = TextAlign.start,
  double textScaleFactor = 1,
  Color? color,
}) {
  TextStyle textStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
    color: color
  );

  return RichText(
    textAlign: textAlign,
    textScaleFactor: textScaleFactor,

    text: TextSpan(
      style: textStyle,
      children: [
        const TextSpan(text: 'Heb je ideeën of verbeterpunten voor deze app? Stuur dan een '),
        TextSpan(
          text: 'e-mail',
          style: linkStyle,
          recognizer: TapGestureRecognizer()..onTap = () { launchUrl(emailUrl); },
        ),
        const TextSpan(text: ', of '),
        TextSpan(
          text: 'maak een issue op GitHub',
          style: linkStyle,
          recognizer: TapGestureRecognizer()..onTap = () async {
            if (await canLaunchUrl(githubNewIssueUrl)) {
              launchUrl(githubNewIssueUrl, mode: LaunchMode.externalApplication);
            }
          },
        ),
        const TextSpan(text: '.'),
      ]
    )
  );
}
