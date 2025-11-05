import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/extension/context_extension.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/chat/cubit/chat_cubit.dart';
import 'package:hawiah_client/features/chat/model/chat_model.dart';
import 'package:hawiah_client/features/chat/presentation/screens/chat-screen.dart' hide DateMethods;
import 'package:hawiah_client/features/chat/presentation/widget/message_widget.dart';

class SingleChatScreenArgs {
  final String senderId;
  final String receiverId;
  final String receiverImage;
  final String receiverName;
  final String senderType;
  final String receiverType;
  final String orderId;
  final VoidCallback onMessageSent;

  SingleChatScreenArgs({
    required this.senderId,
    required this.senderType,
    required this.orderId,
    required this.receiverImage,
    required this.receiverName,
    required this.receiverId,
    required this.receiverType,
    required this.onMessageSent,
  });
}

class SingleChatScreen extends StatefulWidget {
  final SingleChatScreenArgs args;
  static const routeName = 'ChatScreen';

  const SingleChatScreen({super.key, required this.args});

  @override
  State<SingleChatScreen> createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final _messageEC = TextEditingController();
  late ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();
    _chatCubit = ChatCubit();
    _chatCubit.initialize(widget.args.orderId);

    _chatCubit.updateUserStatus(
      orderId: widget.args.orderId,
      userType: widget.args.senderType,
      isOnline: true,
    );
  }

  @override
  void dispose() {
    _chatCubit.updateUserStatus(
      orderId: widget.args.orderId,
      userType: widget.args.senderType,
      isOnline: false,
    );
    _chatCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.args.onMessageSent.call();
        }
      },
      child: BlocProvider(
        create: (context) => _chatCubit,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .doc(widget.args.orderId)
                  .snapshots(),
              builder: (context, snapshot) {
                String statusText = '';

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  final receiverType = widget.args.receiverType;

                  final bool isOnline = data['${receiverType}_isOnline'] ?? false;
                  final lastSeen = (data['${receiverType}_lastSeen'] as Timestamp?)?.toDate();

                  if (isOnline) {
                    statusText = 'متصل الآن';
                  } else if (lastSeen != null) {
                    statusText = 'آخر ظهور: ${DateMethods.formatToTime(lastSeen)}';
                  } else {
                    statusText = 'غير متصل';
                  }
                }

                return CustomAppBar(
                  appBarColor: AppColor.whiteColor,
                  elevation: 1,
                  context,
                  title: Row(
                    children: [
                      Stack(
                        children: [
                          CustomNetworkImage(
                            imageUrl: widget.args.receiverImage,
                            height: 40,
                            width: 40,
                            radius: 30,
                            fit: BoxFit.cover,
                          ),
                          if (snapshot.hasData &&
                              snapshot.data!.data() != null &&
                              (snapshot.data!.data() as Map<String, dynamic>)[
                                      '${widget.args.receiverType}_isOnline'] ==
                                  true)
                            Positioned(
                              bottom: 8,
                              right: 12,
                              child: Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Gap(5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.args.receiverName,
                            style:
                                AppTextStyle.text14_400.copyWith(fontFamily: context.fontFamily()),
                          ),
                          if (statusText.isNotEmpty)
                            Text(
                              statusText,
                              style: AppTextStyle.text12_400
                                  .copyWith(color: Colors.grey, fontFamily: context.fontFamily()),
                            ),
                        ],
                      ),
                    ],
                  ),
                  centerTitle: false,
                  leadingWidth: 70,

                  leading: GestureDetector(
                      onTap: () => NavigatorMethods.pushNamedAndRemoveUntil(
                          context, AllChatsScreen.routeName),
                      child: BackButton()),

                  actions: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.phone, color: AppColor.textGrayColor),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.video_call, color: AppColor.textGrayColor),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert, color: AppColor.textGrayColor),
                    ),
                  ],
                );
              },
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(child: CustomLoading());
                    } else if (state is ChatError) {
                      return Center(child: Text(state.message));
                    } else if (state is ChatLoaded) {
                      return GroupedListView<ChatMessageModel, DateTime>(
                        elements: state.messages,
                        groupBy: (element) => DateTime(
                          element.timeStamp!.year,
                          element.timeStamp!.month,
                          element.timeStamp!.day,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        itemComparator: (item1, item2) =>
                            item1.timeStamp!.compareTo(item2.timeStamp!),
                        groupItemBuilder: (
                          context,
                          element,
                          groupStart,
                          groupEnd,
                        ) {
                          return MessageWidget(message: element);
                        },
                        groupSeparatorBuilder: (date) => Center(
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                date.day == DateTime.now().day
                                    ? AppLocaleKey.today.tr()
                                    : DateMethods.formatToDate(date),
                              ),
                            ),
                          ),
                        ),
                        separator: const SizedBox(height: 15),
                        reverse: true,
                        order: GroupedListOrder.DESC,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        unFocusColor: AppColor.grayBlueColor.withAlpha(100),
                        fillColor: AppColor.grayBlueColor,
                        controller: _messageEC,
                        hintText: AppLocaleKey.messageHint.tr(),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final txt = _messageEC.text;
                        if (txt.isNotEmpty) {
                          _chatCubit.sendMessage(
                            message: txt,
                            senderId: widget.args.senderId,
                            senderType: widget.args.senderType,
                            receiverId: widget.args.receiverId,
                            receiverType: widget.args.receiverType,
                            receiverName: widget.args.receiverName,
                            receiverImage: widget.args.receiverImage,
                          );
                        }
                        _messageEC.clear();
                      },
                      icon: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColor.mainAppColor,
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppImages.sends,
                                height: 20,
                                width: 20,
                                color: AppColor.whiteColor,
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
