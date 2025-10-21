class Config {
  // API Configuration
  static const String baseUrl = "https://thelocalrent.com";
  static const String apiUrl = "$baseUrl/api/";
  static const String imgUrl = "$baseUrl/uploads/";
  static const String uploadsUrl = "$baseUrl/uploads/";

  // API Endpoints
  static const String loginEndpoint = "${apiUrl}login";
  static const String registerEndpoint = "${apiUrl}register";
  static const String dashboardEndpoint = "${apiUrl}dashboard/";
  static const String allItemsEndpoint = "${apiUrl}allitems/";
  static const String myItemsEndpoint = "${apiUrl}myitems";
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
  static const String orderRejectionEndpoint = "${apiUrl}orderrejection/";
  static const String updateRentalStatusEndpoint =
      "${apiUrl}updaterentalstatus";
  static const String myRentalsEndpoint = "${apiUrl}myrentals/";
  static const String rentalDetailsEndpoint = "${apiUrl}rentaldetails/";
  static const String allBlogsEndpoint = "${apiUrl}allblogs";
  static const String blogDetailsEndpoint = "${apiUrl}blogdetails/";
  static const String getChatedUsersEndpoint = "${apiUrl}getchatedusers/";
  static const String getChatsEndpoint = "${apiUrl}getchats";
  static const String sendMsgEndpoint = "${apiUrl}sendmsg";
  static const String settingsEndpoint = "${apiUrl}settings";
  static const String docEndpoint = "${apiUrl}doc";
}

class ImgAssets {
  // App Assets
  static const String logo = "assets/logorent.png";
  static const String logoShadow = "assets/logo_shadow.png";
  static const String logo2 = "assets/logo2.jpg";
  static const String logo3 = "assets/logo3.png";
  static const String logoRent = "assets/logorent.png";
  static const String noImg = "assets/noimg.png";

  // Placeholder Images
  static const String listingImage1 = 'assets/images/listing1.png';
  static const String listingImage2 = 'assets/images/listing2.png';

  // Icon Assets (if any)
  // static const String iconHome = 'assets/icons/home.png';
}

class ImgLinks {
  // Default/Fallback Images
  static const String profileImage =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQi50zTLuADwdCHUNWNkOxgIh05Uo3ma8euw&s";
  static const String product =
      "https://cdn-icons-png.flaticon.com/128/2674/2674486.png";
  static const String defaultAvatar =
      "https://via.placeholder.com/150/00BCD4/FFFFFF?text=User";

  // Error Images
  static const String errorImage =
      "https://via.placeholder.com/300x200/FF0000/FFFFFF?text=Error";
}
