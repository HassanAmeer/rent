class Api {
  // API Configuration
  static const String baseUrl = "https://thelocalrent.com";
  static const String apiUrl = "$baseUrl/api/";
  static const String imgPath = "$baseUrl/uploads/";
  static const String uploadsUrl = "$baseUrl/uploads/";

  // API Endpoints
  static const String loginEndpoint = "${apiUrl}login";
  static const String registerEndpoint = "${apiUrl}register";
  static const String dashboardEndpoint = "${apiUrl}dashboard/";
  static const String getCatgEndpoint = "${apiUrl}getcatg";
  static const String allItemsEndpoint = "${apiUrl}allitems/";
  static const String myItemsEndpoint = "${apiUrl}myitems";
  static const String updateItemEndpoint = "${apiUrl}edititem";
  static const String addItemEndpoint = "${apiUrl}additem";
  static const String updateProfileEndpoint = "${apiUrl}updateprofile";
  static const String getUserByIdEndpoint = "${apiUrl}getuserbyid/";
  static const String notificationsEndpoint = "${apiUrl}notifications/";
  static const String deleteNotificationEndpoint = "${apiUrl}delnotification/";
  static const String deleteItemEndpoint = "${apiUrl}delitem/";
  static const String unfavEndpoint = "${apiUrl}unfav/";
  static const String addFavEndpoint = "${apiUrl}addfav/";
  static const String getFavEndpoint = "${apiUrl}getfav";
  static const String addOrderEndpoint = "${apiUrl}addorder";
  static const String comingOrdersEndpoint = "${apiUrl}getcommingorders";
  // static const String orderRejectionEndpoint = "${apiUrl}orderrejection/"; deprecated
  // static const String updateRentalStatusEndpoint =
  //     "${apiUrl}updaterentalstatus";
  static const String updateOrderStatus = "${apiUrl}updateorderstatus";
  static const String rentInEndpoint = "${apiUrl}rentin/";
  static const String rentalDetailsEndpoint = "${apiUrl}rentaldetails/";
  static const String allBlogsEndpoint = "${apiUrl}allblogs";
  static const String blogDetailsEndpoint = "${apiUrl}blogdetails/";
  static const String getChatedUsersEndpoint = "${apiUrl}getchatedusers/";
  static const String getChatsEndpoint = "${apiUrl}getchats";
  static const String sendMsgEndpoint = "${apiUrl}sendmsg";
  static const String settingsEndpoint = "${apiUrl}settings";
  static const String docEndpoint = "${apiUrl}doc";
}
