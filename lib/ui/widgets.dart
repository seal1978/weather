import 'package:flutter/material.dart';
import 'package:weather/ui/screen.dart';

weatherPicWidget(String url, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/10),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        )),
  );
}


  showToast(context) {
    Widget toastSuccessed = Container(
        width: Adapt.px(100),
        height: Adapt.px(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text("No data!"),
    
          ],
        ));
    Toast.show(context, toastSuccessed);
  }

  class Toast {
  static ToastImp lastOverlayEntry;

  static show(BuildContext context, Widget childWidget) {
    lastOverlayEntry?.dismiss();
    lastOverlayEntry = null;

    AnimationController animShowController = AnimationController(
      vsync: Overlay.of(context),
      duration: Duration(milliseconds: 300),
    );
    AnimationController animGoneController = AnimationController(
      vsync: Overlay.of(context),
      duration: Duration(milliseconds: 300),
    );
    Animation<double> animShow =
        Tween(begin: 0.0, end: 1.0).animate(animShowController);
    Animation<double> animGone =
        Tween(begin: 1.0, end: 0.0).animate(animGoneController);

 // OverlayEntry负责构建布局
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return IgnorePointer(
        // 去掉Overlay的点击拦截
        ignoring: true,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: AnimatedBuilder(
              builder: (BuildContext context, Widget child) {
                return AnimatedBuilder(
                  builder: (BuildContext context, Widget child) {
                    return Center(
                      child: Opacity(
                        child: Opacity(
                          child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.grey[500].withAlpha(220),
                                  borderRadius: BorderRadius.circular(8)),
                              child: childWidget
                              ),
                          opacity: animGone.value,
                        ),
                        opacity: animShow.value,
                      ),
                    );
                  },
                  animation: animGone,
                );
              },
              animation: animShow,
            ),
          ),
        ),
      );
    });
    ToastImp toastImp =
        ToastImp(context, overlayEntry, animShowController, animGoneController);
    lastOverlayEntry = toastImp;
    toastImp.showToast();
  }
}

class ToastImp {
  BuildContext context;
  OverlayEntry overlayEntry;
  AnimationController show;
  AnimationController gone;
  bool dismissed = false;

  ToastImp(this.context, this.overlayEntry, this.show, this.gone);

  showToast() async {
    Overlay.of(context).insert(overlayEntry);
    show.forward();
    await Future.delayed(Duration(milliseconds: 3000));
    this.dismiss();
  }

  dismiss() async {
    if (dismissed) {
      return;
    }
    this.dismissed = true;
    gone.forward();
    await Future.delayed(Duration(milliseconds: 300));
    overlayEntry?.remove();
  }
}