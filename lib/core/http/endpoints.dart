part of 'http.dart';

abstract interface class Endpoints {
  static const String baseUrl = 'https://taqseet.premiumasp.net/api/client/';
  static const String forgetPassword = "auth/forgot-password";
  static const String verifyOtp = "auth/verify-otp";
  static const String resetPassword = "auth/client-reset-password";
  static const String login = "auth/login";
  static const String refreshToken =
      "https://taqseet.premiumasp.net/api/auth/refresh-token";
  static const String register = "auth/register";
  static const String getProduct = "products";
  static const String catagory = "categories";
  static const String addToCart = "cart/items";
  static const String getCart = "cart";
  static const String clearCart = "cart";
  static String updateCartItem(int cartItemId) => "cart/items/$cartItemId";
  static String deleteCartItem(int cartItemId) => "cart/items/$cartItemId";
  static const String createOrder = "orders";
  static const String getContracts = "contracts";
  static const String getRecentContracts = "contracts/recent";
  static String getContractInstallments(int contractId) =>
      "contracts/$contractId/installments";
  static const String overdueInstallments = "installments/overdue";
  static const String recentPayments = "payments/recent";
  static const String dashboardSummary = "dashboard-summary";
  static const String contractProducts = "contract-products";
  static const String getProfile = "profile";
  static String statementByProduct(int productId) =>
      "contracts/by-product/$productId/statement";
  static const String logout = "https://taqseet.premiumasp.net/api/auth/logout";
}

abstract interface class EndPoints {
  static const String baseUrl = Endpoints.baseUrl;
  static const String login = Endpoints.login;
  static const String register = Endpoints.register;

  static const String forgetPassword = Endpoints.forgetPassword;
  static const String resetPassword = Endpoints.resetPassword;
  static const String getProduct = Endpoints.getProduct;
  static const String logout = Endpoints.logout;
  static const String catagory = Endpoints.catagory;
}
