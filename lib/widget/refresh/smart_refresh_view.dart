import 'package:development_skeleton/base/su_controller.dart';
import 'package:development_skeleton/widget/multi_state_view.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'refresh_controller.dart';

///# 下拉刷新组件
///
///## 说明：下拉刷新，上拉加载更多组件，内部包裹可滑动组件。一般与[RefreshController]配合使用。
class SmartRefreshView<T extends RefreshController> extends StatelessWidget {
  /// 组件id，页面中存在多个[MultiStateView]或者[SmartRefreshView]时，可以使用[id]对其进行区分。
  final String? id;

  /// 页面控制器
  final T controller;

  /// 页面构造函数，请传入可滑动组件
  final Widget Function() contentBuilder;

  /// 空页面状态构造函数
  final Widget Function()? emptyBuilder;

  /// 错误页面状态构造函数
  final Widget Function()? errorBuilder;

  /// 加载页面状态构造函数
  final Widget Function()? loadingBuilder;

  /// 是否可以下拉刷新
  final bool enableRefresh;

  /// 是否可以上拉加载
  final bool enableLoadMore;

  /// GetBuilder Tag
  final String? tag;

  const SmartRefreshView({
    super.key,
    this.id,
    required this.controller,
    required this.contentBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.enableRefresh = true,
    this.enableLoadMore = false,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: controller.refreshCtrl,
      onRefresh: enableRefresh ? () => controller.startRefresh(id) : null,
      onLoad: enableLoadMore ? () => controller.startLoadMore(id) : null,
      child: GetBuilder(
        id: id,
        tag: tag,
        init: controller,
        builder: (_) {
          switch (controller.viewState) {
            case ViewState.loading:
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: null != loadingBuilder ? loadingBuilder!() : const LoadingView(),
                  )
                ],
              );
            case ViewState.content:
              return contentBuilder();
            case ViewState.empty:
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: null != emptyBuilder ? emptyBuilder!() : const EmptyView(),
                  )
                ],
              );
            case ViewState.error:
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: null != errorBuilder ? errorBuilder!() : const ErrorView(),
                  )
                ],
              );
          }
        },
      ),
    );
  }
}
