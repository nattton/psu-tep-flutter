class MessageResponse {
  final String message;

  MessageResponse(this.message);

  MessageResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'];
}

class ErrorResponse {
  final String error;

  ErrorResponse(this.error);

  ErrorResponse.fromJson(Map<String, dynamic> json) : error = json['error'];
}
