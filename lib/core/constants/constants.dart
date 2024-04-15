import 'package:flutter/material.dart';
import 'package:cavalcade/features/feed/feed_screen.dart';
import 'package:cavalcade/features/posts/screens/add_post_screen.dart';

class Constants {
  static const logoPath = 'assets/images/logo.png';
  static const loginbackgroundPath = 'assets/images/login_background.png';
  static const googlePath = 'assets/images/google.png';
  static const profilePicturePath = 'https://img.freepik.com/free-photo/user-front-side-with-white-background_187299-40007.jpg?w=826&t=st=1713218621~exp=1713219221~hmac=ce6eb7fc074873b89420b9864feaaa87f5189c79b550253b25f031dd8af6093a';
  static const communityDefaultBannerPath = 'https://images.pexels.com/photos/346529/pexels-photo-346529.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  static const communityDefaultPicturePath = 'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?w=826&t=st=1712091632~exp=1712092232~hmac=7057c6ae044e51ee69e3287d0e6ae266e1034a0bb8a6a86a92b9d009ed9d2a55';
  static const bannerPath = 'https://images.pexels.com/photos/1955134/pexels-photo-1955134.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];

  static const IconData up = IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down = IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesome': '${Constants.awardsPath}/awesome.png',
    '200_iq': '${Constants.awardsPath}/200_iq.png',
    'badge': '${Constants.awardsPath}/badge.png',
    'helpful_tips': '${Constants.awardsPath}/helpful_tips.png',
    'important': '${Constants.awardsPath}/important.png',
    'question_mark': '${Constants.awardsPath}/question_mark.png',
    'thank_you': '${Constants.awardsPath}/thank_you.png',
    'trophy': '${Constants.awardsPath}/trophy.png',
    'heart': '${Constants.awardsPath}/heart.png',
  };
}