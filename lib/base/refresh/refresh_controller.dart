import 'package:development_skeleton/base/base_controller.dart';
import 'package:development_skeleton/http/http_helper_exception.dart';
import 'package:easy_refresh/easy_refresh.dart';

///# 戴刷新的控制器
///
///## 说明：页面中存在上拉加载，下拉刷新时，使用此控制器。
///
///@date：2024/9/6
abstract class RefreshController extends BaseController {
  Map<String, dynamic> pageBody = {'pageIndex': 1, 'pageSize': 10};

  final EasyRefreshController refreshCtrl = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///# 下拉刷新复写函数
  ///
  ///## 说明：函数内写下拉刷新的接口
  ///
  ///## 返回值：本次请求是否有数据返回
  Future<bool> onRefresh();

  ///# 上拉加载更多复写函数
  ///
  ///## 说明：函数内写上拉加载更多的接口
  ///
  ///## 返回值：是否还有未加载的数据存在
  Future<bool> onLoadMore() => Future(() => false);

  ///# 下拉刷新
  ///
  ///## 说明：调用获取下拉刷新的数据
  Future startRefresh() async {
    pageBody['pageIndex'] = 1;
    try {
      if (await onRefresh()) {
        showContent();
        refreshCtrl.resetFooter();
      } else {
        showEmpty();
      }
      refreshCtrl.finishRefresh(IndicatorResult.success);
    } on HttpHelperException catch(error) {
      //网络请求异常捕获处理
      showError(error.message);
      refreshCtrl.finishRefresh(IndicatorResult.fail);
    }
  }

  ///# 上拉加载
  ///
  ///## 说明：调用获取上拉加载的数据
  startLoadMore([dynamic param]) async {
    pageBody['pageIndex']++;
    try {
      if (await onLoadMore()) {
        refreshCtrl.finishLoad(IndicatorResult.success);
      } else {
        refreshCtrl.finishLoad(IndicatorResult.noMore);
      }
      update();
    } on HttpHelperException catch(_) {
      refreshCtrl.finishLoad(IndicatorResult.fail);
      update();
      pageBody['pageIndex']--;
    }
  }

  @override
  void onClose() {
    super.onClose();
    refreshCtrl.dispose();
  }
}