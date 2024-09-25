import 'package:development_skeleton/base/base_controller.dart';
import 'package:development_skeleton/widget/shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///# 多状态View
///
///## 说明：多状态View
class MultiStateView<T extends BaseController> extends StatelessWidget {
  final T controller;
  final Widget Function() contentBuilder;
  final Widget Function()? emptyBuilder;
  final Widget Function()? errorBuilder;
  final Widget Function()? loadingBuilder;
  final String? tag;

  const MultiStateView({
    super.key,
    required this.controller,
    required this.contentBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      tag: tag,
      builder: (_) {
        switch (controller.viewState) {
          case ViewState.loading:
            return null != loadingBuilder ? loadingBuilder!() : const LoadingView();
          case ViewState.content:
            return contentBuilder();
          case ViewState.empty:
            return null != emptyBuilder ? emptyBuilder!() : const EmptyView();
          case ViewState.error:
            return null != errorBuilder ? errorBuilder!() : const ErrorView();
        }
      },
    );
  }
}

class LoadingView extends StatelessWidget {
  final double _ratio = 1 / 6;
  final double _padding = 20;

  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: (height / (width * _ratio + _padding)).toInt(),
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          period: const Duration(milliseconds: 1000),
          baseColor: const Color(0xFFE0E0E0),
          highlightColor: const Color(0xFFFAFAFA),
          enabled: true,
          child: Padding(
            padding: EdgeInsets.all(_padding),
            child: Row(
              children: [
                Container(
                  width: width * _ratio,
                  height: width * _ratio,
                  color: const Color(0xFFE0E0E0),
                ),
                SizedBox(width: width / 20),
                Expanded(
                  child: SizedBox(
                    height: width * _ratio,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width / 3,
                          height: width * _ratio / 4,
                          color: const Color(0xFFE0E0E0),
                        ),
                        Container(
                          width: double.infinity,
                          height: width * _ratio / 4,
                          color: const Color(0xFFE0E0E0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty_outlined),
          SizedBox(width: 10),
          Text('数据为空'),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 10),
          Text('数据异常'),
        ],
      ),
    );
  }
}
