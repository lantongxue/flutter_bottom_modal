import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// modal 按钮类型
enum FlutterBottomModalButtonType {
  /// 只有一个取消按钮
  onlyCancel,

  /// 左边取消，右边确定
  cancelAndOK,

  /// 自定义
  custom
}

class FlutterBottomModal {
  static Future<dynamic> show(BuildContext context, {
    String title = '提示',
    Color backgroundColor = Colors.white,
    List<Widget> children = const <Widget>[],
    FlutterBottomModalButtonType type = FlutterBottomModalButtonType.onlyCancel,
    Function okBtnPressed,
    WidgetBuilder build
  }) {
    final double screenHeight =  MediaQuery.of(context).size.height;
    return showCupertinoModalPopup(
        context: context,
        useRootNavigator: false,
        builder: (b) {
          final double dialogHeight = screenHeight / 2;
          return Container(
            height: dialogHeight,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0)
                )
            ),
            child: Column(
              children: <Widget>[
                // 标题
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        decoration: TextDecoration.none,
                        color: Colors.black
                    ),
                  ),
                ),
                // 选项
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0
                      ),
                      child: ListBody(
                        children: children,
                      ),
                    ),
                  ),
                ),
                _buildButton(context, type, build: build, okBtnPressed: okBtnPressed),
              ],
            ),
          );
        }
    );
  }

  static Widget _buildButton(BuildContext context, FlutterBottomModalButtonType type, {WidgetBuilder build, Function okBtnPressed}) {
    /// 按钮左右外边距的和
    final double btnMarginLeftAndRightSum = 40.0;
    final double screenWidth = MediaQuery.of(context).size.width;
    switch(type) {
      case FlutterBottomModalButtonType.onlyCancel:
        return _modalButton('取消', () => Navigator.pop(context), width: screenWidth - btnMarginLeftAndRightSum);
      case FlutterBottomModalButtonType.cancelAndOK:
        final double btnWidth = screenWidth / 2 - btnMarginLeftAndRightSum;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _modalButton('取消', () => Navigator.pop(context), width: btnWidth),
            _modalButton('确定', (){
              Navigator.pop(context);
              okBtnPressed();
            }, width: btnWidth, btnColor: Colors.blueAccent)
          ],
        );
      case FlutterBottomModalButtonType.custom:
        return build(context);
    }
    return null;
  }

  static Widget _modalButton(String text, Function onPressed, {double width, Color btnColor}) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      height: 46.0,
      width: width, // 这里的40是左右两边的边距
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(18.0)
      ),
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        borderSide: BorderSide.none,
        splashColor: Colors.transparent,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: btnColor == null ? Colors.grey[600] : btnColor
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}