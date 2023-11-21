import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colored_progress_indicators/flutter_colored_progress_indicators.dart';
import 'package:flutter_store_catalog/core/blocs/splash_web_load/splash_web_load_bloc.dart';
import 'package:flutter_store_catalog/core/utilities/dialog_util.dart';
import 'package:flutter_store_catalog/ui/router.dart';
import 'package:flutter_store_catalog/ui/shared/colors.dart';
import 'package:flutter_store_catalog/ui/shared/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  final String token;

  const SplashPage({Key key, this.token}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SplashWebLoadBloc>(context).add(
      SplashWebLoadInitEvent(widget.token),
    );

    _initData();
  }

  _initData() async {
    if (!mounted) return;

    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<SplashWebLoadBloc>(context),
      listener: (context, state) async {
        if (state is ErrorSplashWebLoadState) {
          DialogUtil.showErrorDialog(context, state.error);
        } else if (state is SuccessSplashWebLoadState) {
          Navigator.pushNamedAndRemoveUntil(context, WebRoutePaths.Home, (route) => false);
        }
      },
      child: Scaffold(
        body: InkWell(
          onTap: () {},
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Hero(
                              tag: 'splashscreenImage',
                              child: Container(child: Image.asset('assets/images/app_logo.png')),
                            ),
                            radius: 100,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              'common.version'.tr(args: ['${_packageInfo?.version}']) + ' build ${_packageInfo.buildNumber}',
                              style: Theme.of(context).textTheme.large.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: BlocBuilder<SplashWebLoadBloc, SplashWebLoadState>(
                      builder: (context, state) {
                        if (state is LoadingSplashWebLoadState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 64,
                                width: 64,
                                child: ColoredCircularProgressIndicator(strokeWidth: 8),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Loading... ',
                                  style: Theme.of(context).textTheme.normal.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: '${state.mode}',
                                      style: Theme.of(context).textTheme.normal.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorAccent,
                                          ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          );
                        }

                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
