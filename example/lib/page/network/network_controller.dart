import 'package:development_skeleton/development_skeleton.dart';
import 'package:example/config/http/http_instance.dart';
import 'package:example/entity/article_entity.dart';
import 'package:example/entity/user_info_entity.dart';

///# 网络请求
///
///@date 2024/9/10
class NetworkController extends BaseController {
  ResultType resultType = ResultType.entity;
  UserInfoEntity? entity;
  List<ArticleEntity> entityList = [];
  List<String> stringList = [];
  String? str = '';

  @override
  init() async {
    // await requestEntity();
    await Future.delayed(const Duration(hours: 100));
    showContent();
  }

  Future requestEntity() async {
    entity = await httpUtils.post(
      url: '/login',
      body: {"username": "user_01", "password": "123456"},
      cancelToken: getCancelToken(),
      onMap: (json) => UserInfoEntity.fromJson(json),
    );
    if (null != entity) {
      showContent();
    } else {
      showError();
    }
  }

  Future request(ResultType? type) async {
    if (null == type) return;
    resultType = type;
    showLoading();
    switch (resultType) {
      case ResultType.entity:
        await requestEntity();
        break;
      case ResultType.entityList:
        await requestEntityList();
        break;
      case ResultType.stringList:
        await requestStringList();
        break;
      case ResultType.string:
        await requestString();
        break;
      case ResultType.noResult:
        await requestNoResult();
        break;
    }
  }

  Future requestEntityList() async {
    List<ArticleEntity>? result = await httpUtils.get(
        url: '/list',
        param: {'userId': 1},
        cancelToken: getCancelToken(),
        onList: (list) => list.buildEntity((item) => ArticleEntity.fromJson(item)));
    if (result.isNotBlank) {
      entityList.clear();
      entityList.addAll(result!);
      showContent();
    } else {
      showEmpty();
    }
  }

  Future requestStringList() async {
    List<String>? result = await httpUtils.get(
      url: '/test',
      param: {'type': 'list_string'},
      cancelToken: getCancelToken(),
    );
    if (result.isNotBlank) {
      stringList.clear();
      stringList.addAll(result!);
      showContent();
    } else {
      showEmpty();
    }
  }

  Future requestString() async {
    str = await httpUtils.get(
      url: '/test',
      param: {'type': 'string'},
      cancelToken: getCancelToken(),
    );
    if (null != str) {
      showContent();
    } else {
      showError();
    }
  }

  Future requestNoResult() async {
    await httpUtils.get(
      url: '/test',
      param: {'type': 'null_result'},
      cancelToken: getCancelToken(),
    );
    showContent();
  }
}

enum ResultType {
  entity('实体对象'),
  entityList('实体对象列表'),
  stringList('字符串列表'),
  string('字符串'),
  noResult('不关心返回');

  final String name;

  const ResultType(this.name);
}
