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
    final faqList = [
      {
        'question': '1. ما هو تطبيق حاوية؟',
        'answer':
            'هو تطبيق ذكي يسهّل عليك طلب حاوية نفايات كبيرة وجمعها من موقعك بكل سهولة، دون الحاجة للتواصل اليدوي مع الجهات المختصة.',
      },
      {
        'question': '2. كيف أطلب حاوية من خلال التطبيق؟',
        'answer':
            'يمكنك طلب حاوية بسهولة عبر التطبيق باختيار نوع الحاوية والموقع وتأكيد الطلب، وسيتم إرسال فريق مخصص لتوصيلها إليك.',
      },
      {
        'question': '3. كم يستغرق جمع النفايات بعد تقديم الطلب؟',
        'answer':
            'يتم جمع النفايات عادة خلال 24 إلى 48 ساعة من وقت تقديم الطلب، حسب موقعك وتوافر الفرق الميدانية.',
      },
      {
        'question': '4. هل يمكنني الإبلاغ عن حاوية ممتلئة أو تالفة؟',
        'answer':
            'نعم، يمكنك الإبلاغ من خلال التطبيق عبر قسم "الإبلاغ عن مشكلة" وسيتم التعامل مع الطلب فورًا.',
      },
      {
        'question': '5. هل التطبيق مجاني؟',
        'answer':
            'نعم، تحميل التطبيق واستخدامه مجاني، ولكن قد تترتب رسوم رمزية على بعض الخدمات مثل جمع النفايات أو توفير الحاويات الخاصة.',
      },
      {
        'question': '6. ما أنواع النفايات التي يتم وضعها في الحاويات؟',
        'answer':
            'تُقبل النفايات المنزلية، والمخلفات العامة، وبعض أنواع النفايات الإنشائية، حسب نوع الحاوية المطلوبة.',
      },
      {
        'question': '7. هل يمكن تحديد موعد معين لجمع الحاوية؟',
        'answer':
            'نعم، يمكنك اختيار الوقت المناسب لك أثناء تقديم الطلب وسيتم التنسيق مع فريق الجمع وفقًا لذلك.',
      },
      {
        'question': '8. كيف أعرف أن طلبي تم استقباله بنجاح؟',
        'answer':
            'بعد إرسال الطلب، ستظهر لك رسالة تأكيد داخل التطبيق، كما يمكنك متابعة حالة الطلب في صفحة "طلباتي".',
      },
      {
        'question': '9. هل يمكنني تعديل أو إلغاء الطلب بعد إرساله؟',
        'answer':
            'يمكنك تعديل أو إلغاء الطلب قبل بدء عملية التوصيل، وذلك من خلال صفحة "طلباتي" داخل التطبيق.',
      },
      {
        'question': '10. كيف يمكنني التواصل مع فريق الدعم؟',
        'answer':
            'يمكنك التواصل مع فريق الدعم عبر الدردشة المباشرة داخل التطبيق أو من خلال البريد الإلكتروني أو الاتصال الهاتفي.',
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.frequentlyAskedQuestions.tr(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final item = faqList[index];
          return CustomExpandableTile(
            title: item['question']!,
            children: [
              Text(
                item['answer']!,
                style: AppTextStyle.text16_400.copyWith(color: AppColor.greyTextColor),
              ),
            ],
          );
        },
      ),
    );
  }
}
