import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/chat/cubit/chat_cubit.dart';
import 'package:hawiah_client/features/chat/model/chat_model.dart';
import 'package:hawiah_client/features/chat/presentation/screens/single-chat-screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  late ChatCubit chatCubit;
  late String userId;
  final TextEditingController _searchController = TextEditingController();
  List<RecentChatModel> _allChats = [];
  List<RecentChatModel> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    userId = context.read<ProfileCubit>().user!.id.toString();
    chatCubit = ChatCubit();
    chatCubit.fetchRecentChats(
      currentId: userId,
      currentType: 'user',
    );
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    chatCubit.close();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredChats = List.from(_allChats);
      } else {
        _filteredChats = _allChats.where((chat) {
          final name = chat.receiverName.toLowerCase();
          final id = chat.orderId.toLowerCase();
          return name.contains(query) || id.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatCubit,
      child: Scaffold(
        extendBody: true,
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.chat.tr(),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              _buildSearchField(),
              Gap(10.h),
              Divider(color: Colors.grey.shade300),
              Expanded(
                child: BlocListener<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if (state is RecentChatsLoaded) {
                      _allChats = state.chats;
                      _filteredChats = List.from(_allChats);
                    }
                  },
                  child: BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RecentChatsLoaded) {
                        final chats = _filteredChats;
                        return ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Stack(
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: chat.receiverImage,
                                        fit: BoxFit.fill,
                                        height: 40,
                                        width: 40,
                                        radius: 30,
                                      ),
                                      Positioned(
                                        bottom: 2,
                                        left: 2,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color:
                                                chat.isOnline == true ? Colors.green : Colors.grey,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    chat.receiverName,
                                    style: AppTextStyle.text14_400,
                                  ),
                                  subtitle: Text(
                                    chat.lastMessage,
                                    style: AppTextStyle.text12_400.copyWith(
                                      color: AppColor.greyColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Text(
                                    chat.lastMessageTime != null
                                        ? DateMethods.formatToTime(chat.lastMessageTime)
                                        : '',
                                    style:
                                        AppTextStyle.text12_400.copyWith(color: AppColor.greyColor),
                                  ),
                                  onTap: () {
                                    NavigatorMethods.pushNamed(
                                      context,
                                      SingleChatScreen.routeName,
                                      arguments: SingleChatScreenArgs(
                                        receiverId: chat.receiverId,
                                        receiverType: 'driver',
                                        receiverName: chat.receiverName,
                                        receiverImage: chat.receiverImage,
                                        senderId: userId,
                                        senderType: 'user',
                                        orderId: chat.orderId,
                                        onMessageSent: () {
                                          chatCubit.fetchRecentChats(
                                            currentId: userId,
                                            currentType: 'user',
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                Divider(color: Colors.grey.shade300),
                              ],
                            );
                          },
                        );
                      } else if (state is ChatError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Material(
      elevation: 4,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(12),
      child: CustomTextField(
        controller: _searchController,
        hintText: AppLocaleKey.findAConversation.tr(),
        hintStyle: TextStyle(color: const Color(0xff979797), fontSize: 15.sp),
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.search, color: AppColor.mainAppColor, size: 25),
      ),
    );
  }
}

class DateMethods {
  static String formatToTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'منذ لحظات';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسبوع';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months شهر';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'منذ $years سنة';
    }
  }
}
