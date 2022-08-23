// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/colors.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/chats_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/message/message_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/message_thread/message_thread_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/receipt/receipt_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/typing/typing_notification_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/theme.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/widgets/message_thread/receiver_message.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/widgets/message_thread/sender_message.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/widgets/shared/header_status.dart';

class MessageThread extends StatefulWidget {
  User receiver;
  User me;
  final String chatId;
  final MessageBloc messageBloc;
  final TypingNotificationBloc typingNotificationBloc;
  final ChatsCubit chatsCubit;
  MessageThread(this.receiver, this.me, this.messageBloc, this.chatsCubit,
      this.typingNotificationBloc,
      {Key? key, String chatId = ''})
      // ignore: unnecessary_this, prefer_initializing_formals
      : this.chatId = chatId, super(key: key);

  @override
  State<MessageThread> createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();
  String chatId = '';
  late User receiver;
  late StreamSubscription _subscription;
  late List<LocalMessage> messages = [];
  Timer _startTypingTimer = Timer(Duration(seconds: 0), () {});
  Timer _stopTypingTimer = Timer(Duration(seconds: 0), () {});

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    receiver = widget.receiver;
    _updateOnMessageReceived();
    _updateOnReceiptReceived();
    context.read<ReceiptBloc>().add(ReceiptEvent.onSubscribed(widget.me));
    widget.typingNotificationBloc.add(TypingNotificationEvent.onSubscribed(
        widget.me,
        userWithChat: [receiver.id]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isLightTheme(context) ? Colors.black : Colors.white,
            ),
          ),
          Expanded(
              child:
                  BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
            bloc: widget.typingNotificationBloc,
            builder: (__, state) {
              bool typing = false;
              if (state is TypingNotificationReceivedSuccess &&
                  state.event.event == Typing.start &&
                  state.event.from == receiver.id) {
                typing = true;
              }
              return HeaderStatus(
                receiver.username,
                receiver.photoUrl,
                receiver.active,
                lastSeen: receiver.lastseen,
                typing: typing,
              );
            },
          )),
        ]),
      ),
      resizeToAvoidBottomInset:
          true, //? to resize widgets when the keyboard pops up
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          //? when user taps anywhere outside the keyboard will close and focus will be on the main screen
        },
        child: Column(
          children: [
            Flexible(
              flex: 6, //? Majority of screen covered
              child: BlocBuilder<MessageThreadCubit, List<LocalMessage>>(
                builder: (__, messages) {
                  this.messages = messages;
                  if (this.messages.isEmpty)
                    return Container(color: Colors.transparent);
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToEnd());
                  //? Will run when list view has rendered or will render again and call the method
                  return _buildListOfMessages();
                },
              ),
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: isLightTheme(context) ? Colors.white : kAppBarDark,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -3),
                    blurRadius: 6.0,
                    color: Colors.black12,
                  ),
                ],
              ),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildMessageInput(context),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 6.0),
                      height: 45.0,
                      width: 45.0,
                      child: RawMaterialButton(
                        fillColor: kPrimary,
                        shape: CircleBorder(),
                        elevation: 5.0,
                        child: Icon(
                          Icons.send_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _sendMessage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildMessageInput(BuildContext context) {
    final _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(90.0),
      borderSide: isLightTheme(context)
          ? BorderSide.none
          : BorderSide(color: Colors.grey.withOpacity(0.3)),
    );
    return Focus(
      onFocusChange: (focus) {
        if (_startTypingTimer == null || (_startTypingTimer != null && focus)) {
          return;
        }
        _stopTypingTimer.cancel();
        _dispatchTyping(Typing.stop);
      },
      child: TextFormField(
        controller: _textEditingController,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: Theme.of(context).textTheme.caption,
        cursorColor: kPrimary,
        onChanged: _sendTypingNotification,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          enabledBorder: _border,
          filled: true,
          fillColor:
              isLightTheme(context) ? kPrimary.withOpacity(0.1) : kBubbleDark,
          focusedBorder: _border,
        ),
      ),
    );
  }

  _buildListOfMessages() => ListView.builder(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, bottom: 20.0),
        itemBuilder: (__, idx) {
          if (messages[idx].message.from == receiver.id) {
            //? if a new message arrives we are checking if that message belongs to the chat id we set here
            _sendReceipt(messages[idx]);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ReceiverMessage(messages[idx], receiver.photoUrl),
            );
          } else {
            //? If i sent the message
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SenderMessage(messages[idx]),
            );
          }
        },
        itemCount: messages.length,
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
      );

  void _updateOnMessageReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    if (chatId.isNotEmpty) {
      messageThreadCubit.messages(chatId);
    } //? Fetch all the messages from database if chatId != null
    _subscription = widget.messageBloc.stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await messageThreadCubit.viewModel.recievedMessage(state.message);
        final receipt = Receipt(
          recipient: state.message.from,
          messageId: state.message.id,
          status: ReceiptStatus.read,
          timestamp: DateTime.now(),
        );
        context.read<ReceiptBloc>().add(ReceiptEvent.onMessageSent(receipt));
      }
      if (state is MessageSentSuccess) {
        await messageThreadCubit.viewModel.sentMessage(state.message);
        //? Whenever we sent a successful message we have to write this in a database
      }
      if (chatId.isEmpty) chatId = messageThreadCubit.viewModel.chatId;
      messageThreadCubit.messages(chatId);
    });
  }

  void _updateOnReceiptReceived() {
    final messageThreadCubit = context.read<MessageThreadCubit>();
    context.read<ReceiptBloc>().stream.listen((state) async {
      if (state is ReceiptReceivedSuccess) {
        await messageThreadCubit.viewModel.updateMessageReceipt(state.receipt);
        messageThreadCubit.messages(chatId);
        widget.chatsCubit.chats();
        //? Update the chats on the previous home screen
      }
    });
  }

  _sendMessage() {
    if (_textEditingController.text.trim().isEmpty) return;
    final message = Message(
      from: widget.me.id,
      to: receiver.id,
      timestamp: DateTime.now(),
      contents: _textEditingController.text,
    );
    final sendMessageEvent = MessageEvent.onMessageSent(message);
    widget.messageBloc.add(sendMessageEvent);

    _textEditingController.clear();
    _startTypingTimer?.cancel();
    _stopTypingTimer?.cancel();

    _dispatchTyping(Typing.stop);
  }

  _scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    //? Scroll to the bottom of the list
  }

  void _dispatchTyping(Typing event) {
    final typing =
        TypingEvent(from: widget.me.id, to: receiver.id, event: event);
    widget.typingNotificationBloc
        .add(TypingNotificationEvent.onTypingSent(typing));
  }

  void _sendTypingNotification(String text) {
    if (text.trim().isEmpty || messages.isEmpty) return;
    if (_startTypingTimer.isActive ?? false) return;
    if (_stopTypingTimer.isActive ?? false) _stopTypingTimer.cancel();

    _dispatchTyping(Typing.start);
    _startTypingTimer = Timer(Duration(seconds: 5), () {});
    //? Do every action after 5 seconds or here in case send typing events
    _stopTypingTimer =
        Timer(Duration(seconds: 6), () => _dispatchTyping(Typing.stop));
  }

  _sendReceipt(LocalMessage message) async {
    if (message.receipt == ReceiptStatus.read) return;
    //? if its already marked read, do nothing
    final receipt = Receipt(
      recipient: message.message.to,
      messageId: message.id,  
      status: ReceiptStatus.read,
      timestamp: DateTime.now(),
    );
    context.read<ReceiptBloc>().add(ReceiptEvent.onMessageSent(
        receipt)); //? To update it in rethink Database
    await context
        .read<MessageThreadCubit>()
        .viewModel
        .updateMessageReceipt(receipt); //? To update in SQL  LocalDb
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _subscription?.cancel();
    _startTypingTimer?.cancel();
    _stopTypingTimer?.cancel();
    super.dispose();
  }
}
