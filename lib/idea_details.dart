import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_localizations.dart';
import 'globals.dart' as globals;
class AppIdea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text( AppLocalizations.of(context).translate("more_details"))),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 280,
                  child: Text(
                    getFirstParagraph(),
                    style: GoogleFonts.assistant(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 280,
                  child: Text(
                    getSecondParagraph(),
                    style: GoogleFonts.assistant(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 280,
                  child: Text(
                    getThirdParagraph(),
                    style: GoogleFonts.assistant(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFirstParagraph() {
    return "הרעיון הדמוקרטי קיים כבר אלפי שנים, אך לא מומש במלוא מובנו לעולם.\n"
        "מעתה, במקום שנבחרי הציבור יחליטו אילו חוקים לקדם (שלפעמים מתקבלים ע\"י שיקולים זרים) הכח נמצא בידיים שלנו."
        " אנחנו יכולים להשפיע על נושאים הבוערים לנו ולממש את רעיון 'שלטון העם'. ";
  }

  String getSecondParagraph() {
    return "בתקופה האחרונה אנו עדים לשינוי בהלך הרוח בפרלמנט.\n"
        "כוחות חיצוניים המונעים משיקולים זרים מנסים להשפיע על סדר היום ולנצל את חולשות האבטחה של הדמוקרטיה הנוכחית.";
  }

  String getThirdParagraph() {
    return "כיום, העם בוחר את נציגיו לכנסת פעם ב-4 שנים (למעט מקרים בו הממשלה נופלת לפני כן).\n"
        "דבר המוביל לוואקום שנוצר במשך 4 שנים בהן נבחרי הציבור חופשיים לקדם אינטרסטים שלא בהכרח עולים בקנה מידה עם המצע שהם הציגו לעם לפני הבחירות.\n"
        "\nהרעיון לפלטפורמה בו את/ה משתמש/ת כעת נוצר בדיוק מסיבה זו."
        "הגיעה העת לשלב חדש בהתפתחות האבולציונית של הדמוקרטיה הליברלית ובשימוש בפלטפורמה זו אנו מציגים עידן חדש של שלטון שעובד בשבילנו ולמעננו.\n";
  }
}
