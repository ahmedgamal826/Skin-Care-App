import 'error_model.dart';

final Map<String, AppError> errorMap = {
  //t2 Dio Errors
  // The request returned a bad response, usually a bad request's fault.
  "dio/bad-response": AppError.presentable(
      "dio-br", "There has been an error connecting, please try again later."),
  // Unknown error passed by the dio client.
  "dio/unknown": AppError.presentable(
      "dio-u", "There has been an error connecting, please try again later."),
  //t2 Permissions
  // Permission has been denied perminentaly.
  "c/permission_denied": AppError.presentable("P500",
      "{} permission has been denied, Some functionality might not work correctly.."),
  "c/permission_denied_permenanytly": AppError.presentable("P500",
      "{} permission has been perminently denied, please enable in settings screen")
};
