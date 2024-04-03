import 'package:cavalcade/features/feed/feed_screen.dart';
import 'package:cavalcade/features/posts/screens/add_post_screen.dart';

class Constants {
  static const logoPath = 'assets/images/logo.png';
  static const loginbackgroundPath = 'assets/images/login_background.png';
  static const googlePath = 'assets/images/google.png';
  static const profilePicturePath = 'assets/images/default_profile_picture.png';
  static const communityDefaultBannerPath = 'https://images.pexels.com/photos/346529/pexels-photo-346529.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  static const communityDefaultPicturePath = 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?w=826&t=st=1712091632~exp=1712092232~hmac=7057c6ae044e51ee69e3287d0e6ae266e1034a0bb8a6a86a92b9d009ed9d2a55';
  static const bannerPath = 'https://images.pexels.com/photos/1955134/pexels-photo-1955134.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];
}