class Api {
  // API Configuration
  static const String baseUrl = "https://thelocalrent.com";
  static const String apiUrl = "$baseUrl/api/";
  static const String imgPath = "$baseUrl/uploads/";
  static const String uploadsUrl = "$baseUrl/uploads/";

  // API Endpoints

  // auth start
  static const String loginEndpoint = "${apiUrl}login";
  static const String registerEndpoint = "${apiUrl}register";
  static const String updateProfileEndpoint = "${apiUrl}updateprofile";
  static const String getUserByIdEndpoint = "${apiUrl}getuserbyid/";
  static const String notificationsEndpoint = "${apiUrl}notifications/";
  static const String deleteNotificationEndpoint = "${apiUrl}delnotification/";
  // auth end

  // basic settings data start
  static const String dashboardEndpoint = "${apiUrl}dashboard/";
  static const String getCatgEndpoint = "${apiUrl}getcatg";
  // basic settings data start

  static const String allItemsEndpoint = "${apiUrl}allitems/";
  static const String addOrderEndpoint = "${apiUrl}addorder";

  // my items start
  static const String myItemsEndpoint = "${apiUrl}myitems";
  static const String addItemEndpoint = "${apiUrl}additem";
  static const String updateItemEndpoint = "${apiUrl}edititem";
  static const String deleteItemEndpoint = "${apiUrl}delitem/";
  // my items end

  // fav start
  static const String getFavEndpoint = "${apiUrl}getfav";
  static const String togglefavEndpoint = "${apiUrl}togglefav/";
  // fav end

  // rent out start
  static const String getRentOutOrdersEndpoint = "${apiUrl}getrentoutorders";
  static const String updateRentOutOrder = "${apiUrl}editrentouorder";
  static const String deleteRentOutOrder = "${apiUrl}delrentouorder/";
  static const String updateRentOutOrderStatus =
      "${apiUrl}updaterentoutorderstatus";
  // rent out end

  // rent in start
  static const String rentInEndpoint = "${apiUrl}rentin/";
  static const String updateRentInOrderEndpoint = "${apiUrl}updaterentinorder";
  static const String deleteRentInOrderEndpoint = "${apiUrl}deleterentinorder/";
  // rent in end

  // blogs start
  static const String allBlogsEndpoint = "${apiUrl}allblogs";
  static const String blogDetailsEndpoint = "${apiUrl}blogdetails/";
  // blogs end

  // Chats Start
  static const String getChatedUsersEndpoint = "${apiUrl}getchatedusers/";
  static const String getChatsEndpoint = "${apiUrl}getchats";
  static const String sendMsgEndpoint = "${apiUrl}sendmsg";
  // Chats end

  static const String settingsEndpoint = "${apiUrl}settings";
  static const String docEndpoint = "${apiUrl}doc";
}
