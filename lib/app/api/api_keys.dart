class ApiKeys {
  /// KEYs

  static const authorization = "Authorization";
  static const accept = "Accept";
  static const applicationJson = "application/json";
  static const locale = "Accept-Language";
  static const contentType = "Content-Type";
  static const keyBearer = "Bearer";



  static const pageNumber = "PageNumber";
  static const pageSize = "PageSize";
  static const categoryId = "CategoryId";
  static const notValid = "NotValid";

  /// URLs
  static const baseUrl = "https://systemproject.pythonanywhere.com";
  static const baseUrlProduction = "";


  static const loginUrl = "$baseUrl/auth/token/login/";
  static const sendOtpUrl = "$baseUrl/auth/users/reset_password_confirm/";
  static const validateOtp = "$baseUrl/api/user/v1/validate-otp/";

  static const getNotes = "$baseUrl/api/Profile/";

}
