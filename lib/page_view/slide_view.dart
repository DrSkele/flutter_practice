import 'package:flutter/material.dart';

class MySliderApp extends StatelessWidget {
  const MySliderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker Custom',
      home: SlideView(
        children: [
          Center(
            child: Text('first'),
          ),
          Center(
            child: Text('second'),
          ),
          Center(
            child: Text('third'),
          ),
          Center(
            child: Text('fourth'),
          ),
        ],
      ),
    );
  }
}

class SlideView extends StatefulWidget {
  const SlideView({super.key, required this.children}) : itemBuilder = null;

  const SlideView.builder({
    super.key,
    required Widget Function(BuildContext, int) this.itemBuilder,
  }) : children = null;

  @override
  State<SlideView> createState() => _SlideViewState();

  final List<Widget>? children;
  final Function? itemBuilder;
}

class _SlideViewState extends State<SlideView> {
  late final PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageController = PageController(
      initialPage:
          (widget.children != null) ? widget.children!.length * 10 : 100,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: fixedListView(context),
    );
  }

  Widget fixedListView(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemBuilder: widget.itemBuilder != null
          ? widget.itemBuilder as Widget? Function(BuildContext, int)
          : (context, index) {
              if (widget.children != null) {
                return widget.children![index % widget.children!.length];
              }
              return Container();
            },
    );
  }
}
