class API {
  static const hostConnect = "https://ekatech.co.in/NFC";
  static const hostConnectUser = "$hostConnect/User";

  static const sigup = "$hostConnectUser/userName.php";
  static const validEmail = "$hostConnectUser/validateEmail.php";
  static const checkMobileNumberExists =
      "$hostConnectUser/checkMobileNumberExists.php";
  static const updatePhoneNumber = "$hostConnectUser/userPhone.php";
  static const editUserProfile = "$hostConnectUser/userUpdate.php";
  static const deleteUserProfile = "$hostConnectUser/deleteUser.php";
  static const getUserinfo = "$hostConnectUser/getUserData.php";

  static const hostConnectBusiness = "$hostConnect/Business";

  static const createProfile = "$hostConnectBusiness/basicInfo.php";
  static const getBusinessName = "$hostConnectBusiness/getBusinessName.php";
  static const getProfileCount = "$hostConnectBusiness/getProfileCount.php";
  static const fetchBusinessDetails =
      "$hostConnectBusiness/fetchBusinessDetails.php";
  static const deleteBusinessProfile =
      "$hostConnectBusiness/deleteBusinessProfile.php";
  static const getActiveProfile = "$hostConnectBusiness/getActiveProfile.php";
  static const updateActiveProfile =
      "$hostConnectBusiness/updateActiveProfile.php";
  static const insertActiveProfile =
      "$hostConnectBusiness/insertActiveProfile.php";

  static const hostConnectCard = "$hostConnect/CardDetail";

  static const insertCardRequest = "$hostConnectCard/insertCardDetail.php";
  static const checkCardRequest = "$hostConnectCard/checkRequest.php";

  static const hostConnectConnection = "$hostConnect/Connection";

  static const getConnections = "$hostConnectConnection/getAllConnection.php";
  static const addConnections = "$hostConnectConnection/findIdentifier.php";
  static const deleteConnection = "$hostConnectConnection/deleteConnection.php";
  static const deleteAllConnection =
      "$hostConnectConnection/deleteAllConnections.php";
}
