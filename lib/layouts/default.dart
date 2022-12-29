import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '/utils/etv_style.dart';

class DefaultLayout extends StatefulWidget {
  final String? title;
  final Widget pageContent;
  final bool refreshOnLoad;
  final bool textBackground;
  final List<Widget>? appBarActions;
  final Future<bool> Function()? onRefresh;


  const DefaultLayout({
    required this.pageContent,
    this.title,
    this.refreshOnLoad = false,
    this.textBackground = false,
    this.appBarActions,
    this.onRefresh,
    Key? key
  }) : super(key: key);

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  late EasyRefreshController _controller;
  final indicatorState = IndicatorStateListenable();

  @override
  void initState()
  {
    super.initState();
    _controller = EasyRefreshController(controlFinishRefresh: true);
  }

  @override
  void dispose()
  {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/etv_schild.png'),

        title: widget.title == null ? null : Text(
          widget.title!,
          style: Theme.of(context).textTheme.headline5?.merge(const TextStyle(
            color: almostWhite,
          )),
        ),
        centerTitle: true,

        actions: [
          if (widget.onRefresh != null) _buildRefreshIndicator(context),
          if (widget.appBarActions != null) ...widget.appBarActions!,
        ],
      ),

      backgroundColor:
        !widget.textBackground || Theme.of(context).colorScheme.brightness == Brightness.dark
          ? Theme.of(context).colorScheme.background
          : Colors.white,

      body: EasyRefresh(
        controller: _controller,
        header: ListenerHeader(
          listenable: indicatorState,
          triggerOffset: 110,
        ),

        onRefresh: widget.onRefresh == null ? null : () async {
          final result = await widget.onRefresh!();
          _controller.finishRefresh(result ? IndicatorResult.success : IndicatorResult.fail);
        },
        refreshOnStart: widget.refreshOnLoad,

        child: Container(
          // ETV logo background
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
              image: const AssetImage('assets/etv_background_light.png'),
              colorFilter: ColorFilter.mode(
                Colors.grey.withOpacity(!widget.textBackground ? 0.4 : 0.1),  // better contrast for when text is directly on the background
                BlendMode.srcIn,
              ),
            ),
          ),

          child: widget.pageContent
        ),
      ),
    );
  }

  // Build the indicator widget that appears in the top AppBar
  Widget _buildRefreshIndicator(BuildContext context)
  {
    return ValueListenableBuilder<IndicatorState?>(
      valueListenable: indicatorState,
      builder: (context, state, _) {
        if (state == null) {
          return const SizedBox();
        }

        final mode = state.mode;
        final offset = state.offset;
        final actualTriggerOffset = state.actualTriggerOffset;
        double? value;

        switch (mode) {
          case IndicatorMode.inactive:
            value = 0;
            break;

          case IndicatorMode.drag:
          case IndicatorMode.armed:
            value = math.min(offset / actualTriggerOffset, 1) * 0.95;
            break;

          case IndicatorMode.ready:
          case IndicatorMode.processing:
            value = null;
            break;

          default:
            value = 1;
        }

        Widget indicator;
        if (value != null && value < 0.1) {
          indicator = const SizedBox();
        }
        else if (value == 1) {
          indicator = Icon(
            indicatorState.value?.result == IndicatorResult.success
              ? Icons.done
              : Icons.close,
          );
        }
        else {
          indicator = SizedBox(
            width: 20,
            height: 20,

            child: CircularProgressIndicator(
              color: Theme.of(context).appBarTheme.iconTheme!.color,
              strokeWidth: 2.5,
              value: value,
            )
          );
        }

        return SizedBox(
          width: 56,
          height: 56,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                reverseDuration: const Duration(milliseconds: 100),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: indicator,
              ),
            ],
          )
        );
      }
    );
  }
}
