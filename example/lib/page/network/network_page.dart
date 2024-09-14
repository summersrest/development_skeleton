import 'package:development_skeleton/development_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:example/entity/article_entity.dart';
import 'package:example/entity/user_info_entity.dart';
import 'network_controller.dart';

///# 网络请求
///
///@date 2024/9/10
class NetworkPage extends BasePage<NetworkController> {
  NetworkPage({super.key});

  @override
  NetworkController initController() => NetworkController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络请求'),
        actions: [
          DropdownButton(
            value: ctrl.resultType,
            items: ResultType.values.map((item) {
              return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.name,
                    style: const TextStyle(color: Colors.purple),
                  ));
            }).toList(),
            onChanged: ctrl.request,
          ),
        ],
      ),
      body: MultiStateView(
        controller: ctrl,
        contentBuilder: () {
          switch (ctrl.resultType) {
            case ResultType.entity:
              return _buildEntity(ctrl.entity);
            case ResultType.entityList:
              return _buildEntityListLayout(ctrl.entityList);
            case ResultType.stringList:
              return _buildStringListLayout(ctrl.stringList);
            case ResultType.string:
              return _buildStringLayout(ctrl.str ?? '');
            case ResultType.noResult:
              return _buildNoResultLayout();
          }
        },
      ),
    );
  }

  Widget _buildEntity(UserInfoEntity? entity) {
    if (null == entity) return const ErrorView();
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.black87, fontSize: 17),
      child: Container(
        padding: const EdgeInsets.all(30),
        child: DividerColumn(
          dividerHeight: 20,
          children: [
            Text('用户：${entity.username}'),
            Text('昵称：${entity.nickname}'),
            Text('生日：${entity.birthday}'),
            Text('电话：${entity.phone}'),
            Text('邮箱：${entity.email}'),
            Text('地址：${entity.address.join('、')}'),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityListLayout(List<ArticleEntity> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(list[index].userNickname),
          subtitle: Text(list[index].text),
        );
      },
    );
  }

  Widget _buildStringListLayout(List<String> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) => ListTile(
        title: Text(list[index]),
      ),
    );
  }

  Widget _buildStringLayout(String result) {
    return Center(
      child: Text(
        result,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildNoResultLayout() {
    return const Center(
      child: Text(
        '请求成功',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
