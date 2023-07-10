import 'package:flutter/cupertino.dart';
import 'package:styled_widget/styled_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return <Widget>[
      const CupertinoActivityIndicator(),
      const SizedBox(height: 4),
      const Text('Loading...'),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        )
        .width(width)
        .height(height)
        .center();
  }
}
