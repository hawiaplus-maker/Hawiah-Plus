import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/profile/presentation/widgets/custom_expandable_tile.dart';

class FaqScreen extends StatelessWidget {
  static const String routeName = '/faq-screen';
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final faqList = [
      {
        'question': {'ar': '1. ما هو تطبيق حاوية؟', 'en': '1. What is Hawiah app?'},
        'answer': {
          'ar':
              'هو تطبيق ذكي يسهّل عليك طلب حاوية نفايات كبيرة وجمعها من موقعك بكل سهولة، دون الحاجة للتواصل اليدوي مع الجهات المختصة.',
          'en':
              'It is a smart app that allows you to order a large waste container and have it collected from your location easily, without manual communication with the authorities.'
        },
      },
      {
        'question': {
          'ar': '2. كيف أطلب حاوية من خلال التطبيق؟',
          'en': '2. How can I order a container via the app?'
        },
        'answer': {
          'ar':
              'يمكنك طلب حاوية بسهولة عبر التطبيق باختيار نوع الحاوية والموقع وتأكيد الطلب، وسيتم إرسال فريق مخصص لتوصيلها إليك.',
          'en':
              'You can easily order a container via the app by selecting the type of container, location, and confirming the order. A dedicated team will deliver it to you.'
        },
      },
      {
        'question': {
          'ar': '3. كم يستغرق جمع النفايات بعد تقديم الطلب؟',
          'en': '3. How long does it take to collect the waste after placing the order?'
        },
        'answer': {
          'ar':
              'يتم جمع النفايات عادة خلال 24 إلى 48 ساعة من وقت تقديم الطلب، حسب موقعك وتوافر الفرق الميدانية.',
          'en':
              'Waste is usually collected within 24 to 48 hours after placing the order, depending on your location and the availability of collection teams.'
        },
      },
      {
        'question': {
          'ar': '4. هل يمكنني الإبلاغ عن حاوية ممتلئة أو تالفة؟',
          'en': '4. Can I report a full or damaged container?'
        },
        'answer': {
          'ar':
              'نعم، يمكنك الإبلاغ من خلال التطبيق عبر قسم "الإبلاغ عن مشكلة" وسيتم التعامل مع الطلب فورًا.',
          'en':
              'Yes, you can report it through the "Report an Issue" section in the app, and your request will be handled immediately.'
        },
      },
      {
        'question': {'ar': '5. هل التطبيق مجاني؟', 'en': '5. Is the app free?'},
        'answer': {
          'ar':
              'نعم، تحميل التطبيق واستخدامه مجاني، ولكن قد تترتب رسوم رمزية على بعض الخدمات مثل جمع النفايات أو توفير الحاويات الخاصة.',
          'en':
              'Yes, downloading and using the app is free, but there may be a small fee for some services such as waste collection or providing special containers.'
        },
      },
      {
        'question': {
          'ar': '6. ما أنواع النفايات التي يتم وضعها في الحاويات؟',
          'en': '6. What types of waste can be placed in the containers?'
        },
        'answer': {
          'ar':
              'تُقبل النفايات المنزلية، والمخلفات العامة، وبعض أنواع النفايات الإنشائية، حسب نوع الحاوية المطلوبة.',
          'en':
              'Household waste, general waste, and some types of construction waste are accepted, depending on the type of container required.'
        },
      },
      {
        'question': {
          'ar': '7. هل يمكن تحديد موعد معين لجمع الحاوية؟',
          'en': '7. Can I schedule a specific time for collection?'
        },
        'answer': {
          'ar':
              'نعم، يمكنك اختيار الوقت المناسب لك أثناء تقديم الطلب وسيتم التنسيق مع فريق الجمع وفقًا لذلك.',
          'en':
              'Yes, you can choose a convenient time during order placement, and the collection team will coordinate accordingly.'
        },
      },
      {
        'question': {
          'ar': '8. كيف أعرف أن طلبي تم استقباله بنجاح؟',
          'en': '8. How do I know my order has been successfully received?'
        },
        'answer': {
          'ar':
              'بعد إرسال الطلب، ستظهر لك رسالة تأكيد داخل التطبيق، كما يمكنك متابعة حالة الطلب في صفحة "طلباتي".',
          'en':
              'After placing the order, you will see a confirmation message in the app, and you can track the order status in the "My Orders" page.'
        },
      },
      {
        'question': {
          'ar': '9. هل يمكنني تعديل أو إلغاء الطلب بعد إرساله؟',
          'en': '9. Can I modify or cancel the order after submitting it?'
        },
        'answer': {
          'ar':
              'يمكنك تعديل أو إلغاء الطلب قبل بدء عملية التوصيل، وذلك من خلال صفحة "طلباتي" داخل التطبيق.',
          'en':
              'You can modify or cancel the order before the delivery process starts, via the "My Orders" page in the app.'
        },
      },
      {
        'question': {
          'ar': '10. كيف يمكنني التواصل مع فريق الدعم؟',
          'en': '10. How can I contact the support team?'
        },
        'answer': {
          'ar':
              'يمكنك التواصل مع فريق الدعم عبر الدردشة المباشرة داخل التطبيق أو من خلال البريد الإلكتروني أو الاتصال الهاتفي.',
          'en': 'You can contact the support team via live chat in the app, email, or phone call.'
        },
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: locale == 'ar'
            ? AppLocaleKey.frequentlyAskedQuestions.tr()
            : 'Frequently Asked Questions',
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final item = faqList[index];
          return CustomExpandableTile(
            title: item['question']![locale]!,
            children: [
              Text(
                item['answer']![locale]!,
                style: AppTextStyle.text16_400.copyWith(color: AppColor.greyTextColor),
              ),
            ],
          );
        },
      ),
    );
  }
}
