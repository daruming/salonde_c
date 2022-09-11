enum ErrorState { network, fail, none }

enum UploadState { initial, loading, loaded, fail }

class FireStoreCollection {
  // FireStore User
  static String userCollection = 'all_users';
  static String userRatingSubCollection = 'rating_persons';
  static String userRatedMeSubCollection = 'rated_me';
  static String userFavoritePersonCollection = 'favorite_person';
  static String userGetFavoritePersonCollection = 'get_favorite_person';

  // text chat  - user sub
  static String userTextChatSubCollection = 'user_text_chat';
  // comment chat  - user sub - text chat sub
  static String userCommentSubCollection = 'user_comment';

  // coin - user sub
  static String userCoinSubCollection = 'user_coin';

  //-------------------

  // text chat  - user sub
  static String textChatCollection = 'text_chat';
  // comment chat  - user sub - text chat sub
  static String commentTextChatSubCollection = 'text_chat_comment';

  //-------------------
  // Woman
  static String womanCollection = 'all_woman';

  // Man
  static String manCollection = 'all_man';
}
