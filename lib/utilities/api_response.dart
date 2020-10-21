class ApiResponse {
  var _errors;
  bool _success;
  var _data;
  String _message = "";

  ApiResponse() {
    this._success = false;
    this._data = null;
    this._errors = null;
  }

  getErrors() {
    return this._errors;
  }

  setErrors(errors) {
    this._errors = errors != null ? Map.from(errors) : null;
  }

  setMessage(message) {
    this._message = message ?? "";
  }

  setSuccess(bool success) {
    this._success = success;
  }

  setData(data) {
    this._data = data;
  }

  getData() {
    return this._data;
  }

  getMessage() {
    return this._message;
  }

  hasErrors() {
    return !this._success;
  }

  printData() {
    print(this._data);
  }

  printErrors() {
    print(this._errors);
  }
}
