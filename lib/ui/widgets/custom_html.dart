// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store_catalog/core/utilities/image_util.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';

class CustomHtml extends StatelessWidget {
  final String htmlInput;
  final TextStyle textStyle;

  CustomHtml({this.htmlInput, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlWidget(
        htmlInput,
        webView: true,
        textStyle: textStyle ?? Theme.of(context).textTheme.normal,
        customWidgetBuilder: (e) {
          if (e.localName.toLowerCase() == 'img' && e.attributes['src'].startsWith('http')) {
            e.attributes['src'] = ImageUtil.getFullURL(e.attributes['src']);
          }

          if (e.localName.toLowerCase() == 'iframe') {
            return IframeScreen(url: e.attributes['src']);
          }

          if (e.attributes['style'] != null) {
            List<String> lstStyle = e.attributes['style'].split(';');
            lstStyle.removeWhere((element) => element.trim().toLowerCase().startsWith('font-family'));
            e.attributes['style'] = lstStyle.join(';');
          }

          return null;
        },
      ),
    );
  }
}

class IframeScreen extends StatefulWidget {
  final String url;

  IframeScreen({this.url});

  @override
  _IframeScreenState createState() => _IframeScreenState();
}

class _IframeScreenState extends State<IframeScreen> {
  final IFrameElement _iframeElement = IFrameElement();
  String source;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _iframeElement.src = widget.url;
    _iframeElement.style.border = 'none';

    source = 'iframeElement${Uri.encodeFull(widget.url ?? '')}';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      source,
      (int viewId) => _iframeElement,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width * 0.75;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        height: 400,
        width: _width,
        child: HtmlElementView(
          key: UniqueKey(),
          viewType: source,
        ),
      ),
    );
  }
}
