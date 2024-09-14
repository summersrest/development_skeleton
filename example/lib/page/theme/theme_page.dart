import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:example/config/theme/app_colors.dart';
import 'theme_controller.dart';

///# 主题切换
///
///@date 2024/9/10
class ThemePage extends BasePage<ThemeController> {
  ThemePage({super.key});

  @override
  ThemeController initController() => ThemeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('主题')),
      body: MultiStateView(
        controller: ctrl,
        contentBuilder: () {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: DividerColumn(
              dividerHeight: 20,
              showDividers: const [ShowDivider.beginning, ShowDivider.middle],
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //显示主题自定义主色
                Container(
                  width: 300,
                  height: 300,
                  color: AppColors.of(context).primary,
                ),
                //主题选择
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '主题：',
                        style: TextStyle(
                          color: AppColors.of(context).primary,
                          fontSize: 18,
                        ),
                      ),
                      ...List.generate(ctrl.themeList.length, (index) {
                        ThemeItem item = ctrl.themeList[index];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            Radio(
                              value: item,
                              activeColor: AppColors.of(context).primary,
                              groupValue: ctrl.currentTheme,
                              onChanged: (item) {
                                ctrl.changeTheme(item as ThemeItem);
                              },
                            )
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                //主题模式选择
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '模式：',
                        style: TextStyle(
                          color: AppColors.of(context).primary,
                          fontSize: 18,
                        ),
                      ),
                      ...List.generate(ThemeMode.values.length, (index) {
                        ThemeMode mode = ThemeMode.values[index];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              mode == ThemeMode.system ? '跟随系统' : (mode == ThemeMode.light ? '浅色' : '深色'),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            Radio(
                              value: mode,
                              activeColor: AppColors.of(context).primary,
                              groupValue: ctrl.mode,
                              onChanged: (item) {
                                ctrl.changeThemeMode(item as ThemeMode);
                              },
                            )
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
