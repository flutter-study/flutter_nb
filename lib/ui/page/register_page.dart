import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nb/constants/constants.dart';
import 'package:flutter_nb/ui/widget/loading_widget.dart';
import 'package:flutter_nb/utils/device_util.dart';
import 'package:flutter_nb/utils/dialog_util.dart';
import 'package:flutter_nb/utils/sp_util.dart';
import 'package:rxdart/rxdart.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    DeviceUtil.setBarStatus(true);
    return new Register();
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordSureController = TextEditingController();
  FocusNode firstTextFieldNode = FocusNode();
  FocusNode secondTextFieldNode = FocusNode();
  FocusNode thirdTextFieldNode = FocusNode();
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  Operation operation = new Operation();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new LoadingScaffold(
      //使用有Loading的widget
      operation: operation,
      isShowLoadingAtNow: false,
      child: new Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.white,
        primary: true,
        body: SafeArea(
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(), //内容不足一屏
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            children: <Widget>[
              SizedBox(height: 60.0),
              new Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.blue[100],
                color: Colors.blue[100],
                elevation: 5.0,
                child: new TextField(
                  focusNode: firstTextFieldNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: _usernameController,
                  maxLines: 1,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11), //长度限制11
                    WhitelistingTextInputFormatter.digitsOnly,
                  ], //只能输入整数
                  decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: '最大长度为11个数字',
                      prefixIcon: Icon(Icons.phone_android),
                      contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      )),
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(secondTextFieldNode),
                ),
              ),
              SizedBox(height: 12.0),
              new Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.blue[100],
                color: Colors.blue[100],
                elevation: 5.0,
                child: new TextField(
                    focusNode: secondTextFieldNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: _passwordController,
                    maxLines: 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18),
                      WhitelistingTextInputFormatter(RegExp(Constants.INPUTFORMATTERS))
                    ],
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '请输入密码',
                        prefixIcon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        )),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(thirdTextFieldNode);
                    }),
              ),
              SizedBox(height: 12.0),
              new Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.blue[100],
                color: Colors.blue[100],
                elevation: 5.0,
                child: new TextField(
                    focusNode: thirdTextFieldNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: _passwordSureController,
                    maxLines: 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(18),
                      WhitelistingTextInputFormatter(RegExp(Constants.INPUTFORMATTERS))
                    ],
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: 'Confirm password',
                        hintText: '请确认密码',
                        prefixIcon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.fromLTRB(0, 6, 16, 6),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        )),
                    onEditingComplete: () {
                      _checkInput(context, operation);
                    }),
              ),
              SizedBox(height: 15.0),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.blue[300],
                padding: EdgeInsets.all(8.0),
                shape: new StadiumBorder(
                    side: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.blue,
                )),
                child: Text('立即注册', style: new TextStyle(fontSize: 16.0)),
                onPressed: () {
                  _checkInput(context, operation);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('注册账号'),
        ),
      ),
    );
  }

  void _checkInput(BuildContext context, Operation operation) {
    var username = _usernameController.text;
    if (username.isEmpty) {
      FocusScope.of(context).requestFocus(firstTextFieldNode);
      DialogUtil.buildToast("please enter username.");
      return;
    }
    var password = _passwordController.text;
    if (password.isEmpty) {
      FocusScope.of(context).requestFocus(secondTextFieldNode);
      DialogUtil.buildToast("please enter password.");
      return;
    }

    var passwordSure = _passwordSureController.text;
    if (passwordSure.isEmpty) {
      FocusScope.of(context).requestFocus(thirdTextFieldNode);
      DialogUtil.buildToast("please enter password.");
      return;
    }
    if (password != passwordSure) {
      FocusScope.of(context).requestFocus(thirdTextFieldNode);
      DialogUtil.buildToast("please enter the same password.");
      return;
    }

    operation.setShowLoading(true);
    Observable.just(1).delay(new Duration(milliseconds: 3000)).listen((_) {
      operation.setShowLoading(false);
      DialogUtil.buildToast('注册成功');
      Navigator.pop(context);
    });
  }
}