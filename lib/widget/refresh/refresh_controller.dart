import 'package:development_skeleton/base/su_controller.dart';
import 'package:development_skeleton/http/http_helper_exception.dart';
import 'package:easy_refresh/easy_refresh.dart';

///# 下拉刷新、上拉加载的控制器
///
///## 说明：页面中存在上拉加载，下拉刷新时，使用此控制器。与[SmartRefreshView]组件配合使用。
abstract class RefreshController extends SUController {

  /// 当前页数，上拉加载与下拉刷新后自动计算
  int pageIndex = 1;

  final EasyRefreshController refreshCtrl = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///# 下拉刷新复写函数
  ///
  ///## 说明：函数内写下拉刷新的接口（无需手动调用）
  ///
  ///## 返回值：本次网络请求返回的数组长度
  Future<int> onRefresh();

  ///# 上拉加载更多复写函数
  ///
  ///## 说明：函数内写上拉加载更多的接口（无需手动调用）
  ///
  ///## 返回值：本次网络请求返回的数组长度
  Future<int> onLoadMore() async => 0;

  ///# 开始请求下拉刷新数据
  ///
  /// 调用获取下拉刷新的数据，如果[SmartRefreshView]组件设置了[id]，调用[startRefresh]函数时，也需要添加参数[id]。
  /// 下拉[SmartRefreshView]组件时会自动调用，初始化时可主动调用。
  Future startRefresh([String? id]) async {
    pageIndex = 1;
    try {
      if (await onRefresh() > 0) {
        showContent(id);
        refreshCtrl.resetFooter();
      } else {
        showEmpty(id);
      }
      refreshCtrl.finishRefresh(IndicatorResult.success);
    } on HttpHelperException catch(error) {
      //网络请求异常捕获处理
      showError(id);
      refreshCtrl.finishRefresh(IndicatorResult.fail);
    }
  }

  ///# 开始请求上拉加载更多数据
  ///
  /// 调用获取上拉加载更多的数据，如果[SmartRefreshView]组件设置了[id]，调用[startRefresh]函数时，也需要添加参数[id]。
  /// 上拉[SmartRefreshView]组件时会自动调用。
  startLoadMore([String? id]) async {
    pageIndex++;
    try {
      if (await onLoadMore() > 0) {
        refreshCtrl.finishLoad(IndicatorResult.success);
      } else {
        refreshCtrl.finishLoad(IndicatorResult.noMore);
      }
      update(null != id ? [id] : null);
    } on HttpHelperException catch(_) {
      refreshCtrl.finishLoad(IndicatorResult.fail);
      update(null != id ? [id] : null);
      pageIndex--;
    }
  }

  @override
  void onClose() {
    super.onClose();
    refreshCtrl.dispose();
  }
}