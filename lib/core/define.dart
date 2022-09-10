enum ErrorState { network, fail, none }

enum UploadState { initial, loading, loaded, fail }

class FireStoreCollection {
  // FireStore User
  static String userCollection = 'all_users';
  static String userRatingSubCollection = 'rating_persons';
  static String userRatedMeSubCollection = 'rated_me';
  static String userFavoritePersonCollection = 'favorite_person';
  static String userGetFavoritePersonCollection = 'get_favorite_person';

  // Woman
  static String womanCollection = 'all_woman';

  // Man
  static String manCollection = 'all_man';
}
