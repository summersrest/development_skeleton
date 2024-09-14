import 'package:development_skeleton/base/base_controller.dart';
import 'package:development_skeleton/base/refresh/refresh_controller.dart';
import 'package:development_skeleton/widget/multi_state_view.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///# 下拉刷新组件
///
///## 说明：下拉刷新，上拉加载更多组件，内部包裹可滑动组件。一般与[RefreshController]配合使用。
///
///@date：2024/9/6
class SmartRefreshView<T extends RefreshController> extends StatelessWidget {
  final T controller;
  final Widget Function() contentBuilder;
  final Widget Function()? emptyBuilder;
  final Widget Function()? errorBuilder;
  final Widget Function()? loadingBuilder;
  final bool enableRefresh;
  final bool enableLoadMore;
  final String? tag;

  const SmartRefreshView({
    super.key,
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
      onRefresh: enableRefresh ? controller.startRefresh : null,
      onLoad: enableLoadMore ? controller.startLoadMore : null,
      child: GetBuilder(
        init: controller,
        tag: tag,
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
