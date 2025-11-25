# 💻 Chat Feature - Code Patterns & Examples

## Pattern 1: Offline-First Message Loading

### Before (Without Caching)
```dart
// ❌ No offline support
class MessageController extends GetxController {
  void loadMessages(String chatId) async {
    final result = await _repository.fetchMessages(chatId);
    result.fold(
      (failure) => showError(failure),
      (data) => messages.assignAll(data),
    );
  }
}
```

**Problem:** No messages if offline

### After (With GetStorage)
```dart
// ✅ Offline-first with caching
class MessageController extends GetxController {
  final box = GetStorage();

  void init(String chatId) {
    // Step 1: Load from cache (instant)
    final cached = box.read<List>('chat_$chatId');
    if (cached != null) {
      messages.assignAll(
        cached.map((e) => MessageModel.fromJson(Map.from(e))).toList()
      );
    }

    // Step 2: Refresh from API (background)
    loadMessages(chatId);
  }

  void loadMessages(String chatId) async {
    final result = await _repository.fetchMessages(chatId);
    result.fold(
      (failure) => showError(failure),
      (data) {
        messages.assignAll(data);
        _cacheMessages(chatId);  // Save to storage
      },
    );
  }

  void _cacheMessages(String chatId) {
    final json = messages.map((m) => m.toJson()).toList();
    box.write('chat_$chatId', json);
  }
}
```

**Benefits:** 
- Messages appear instantly from cache
- Background API refresh keeps data fresh
- Works offline
- Automatic save after API response

---

## Pattern 2: Proper StatefulWidget Lifecycle

### Before (Improper)
```dart
// ❌ TextEditingController created in build()
class ChatDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();  // ❌ Creates every rebuild
    
    return TextField(controller: textController);
  }
}
```

**Problems:**
- Memory leak: Old controllers never disposed
- UI jumps: Text resets on rebuild
- Performance: Rebuilds unnecessarily

### After (Proper)
```dart
// ✅ StatefulWidget with proper lifecycle
class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  const ChatDetailScreen({required this.chatId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late TextEditingController _textController;
  late MessageController controller;

  @override
  void initState() {
    super.initState();
    
    // Get or create controller (persistent)
    if (Get.isRegistered<MessageController>()) {
      controller = Get.find<MessageController>();
    } else {
      controller = Get.put(MessageController(), permanent: true);
    }

    // Load messages (cache + API refresh)
    controller.init(widget.chatId);

    // Create controller once
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();  // ✅ Clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.messages.length,
              itemBuilder: (_, i) => MessageBubble(controller.messages[i]),
            )),
          ),
          
          // Input area
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,  // ✅ Reused same instance
                  onChanged: (v) => controller.messageInput.value = v,
                ),
              ),
              Obx(() => ElevatedButton(
                onPressed: controller.isSending.value 
                    ? null 
                    : () => controller.sendMessage(_textController.text),
                child: controller.isSending.value
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                    : Text("Send"),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
```

**Benefits:**
- ✅ Lifecycle properly managed
- ✅ No memory leaks
- ✅ Smooth UI without resets
- ✅ Proper cleanup in dispose()

---

## Pattern 3: Model Serialization with Safe Fallbacks

### Before (Incomplete)
```dart
// ❌ No toJson(), fragile fromJson()
class MessageModel {
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],  // Crashes if missing
      text: json['text'],  // Crashes if missing
      user: ChatUser.fromJson(json['user']),
    );
  }
}
```

**Problems:**
- Crashes if field missing
- Can't be cached (no toJson)
- Type errors from API changes

### After (Safe & Complete)
```dart
// ✅ Complete serialization with safe defaults
class MessageModel {
  final String id;
  final String text;
  final ChatUser user;
  final String date;
  final bool read;

  MessageModel({
    required this.id,
    required this.text,
    required this.user,
    required this.date,
    required this.read,
  });

  // Deserialize from API
  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['_id'] ?? '',  // Safe default
    text: json['text'] ?? '',
    user: ChatUser.fromJson(json['user'] ?? {}),
    date: json['date'] ?? '',
    read: json['read'] ?? false,
  );

  // Serialize for cache storage
  Map<String, dynamic> toJson() => {
    '_id': id,
    'text': text,
    'user': user.toJson(),
    'date': date,
    'read': read,
  };
}

// Nested model with flexible fromJson
class ChatUser {
  final String id;
  final String name;
  final Avatar avatar;

  ChatUser({required this.id, required this.name, required this.avatar});

  // Handles both: "user_id_string" or {"_id": "...", "name": "..."}
  factory ChatUser.fromJson(dynamic json) {
    if (json is String) {
      return ChatUser(id: json, name: '', avatar: Avatar(url: ''));
    }
    if (json is Map) {
      return ChatUser(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        avatar: Avatar.fromJson(json['avatar']),
      );
    }
    return ChatUser(id: '', name: '', avatar: Avatar(url: ''));
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'avatar': avatar.toJson(),
  };
}

class Avatar {
  final String url;

  Avatar({required this.url});

  factory Avatar.fromJson(dynamic json) {
    if (json is Map) return Avatar(url: json['url'] ?? '');
    return Avatar(url: '');
  }

  Map<String, dynamic> toJson() => {'url': url};
}
```

**Benefits:**
- ✅ Never crashes on missing fields
- ✅ Can cache via toJson()
- ✅ Handles API variations
- ✅ Safe nested objects

---

## Pattern 4: GetX - Correct vs Incorrect Usage

### ❌ WRONG: TextField in Obx

```dart
// ❌ BAD - Rebuilds entire TextField when ANY observable changes
@override
Widget build(BuildContext context) {
  return Obx(() => TextField(
    controller: _textController,
    onChanged: (val) => controller.messageInput.value = val,
  ));
}
```

**Problems:**
- Causes TextField to rebuild on every message list update
- Performance degradation
- Violates GetX best practices

### ✅ CORRECT: Only reactive widgets need Obx

```dart
// ✅ GOOD - TextField untouched, only Send button reacts
@override
Widget build(BuildContext context) {
  return Row(
    children: [
      // Plain TextField (no Obx)
      Expanded(
        child: TextField(
          controller: _textController,
          onChanged: (val) => controller.messageInput.value = val,
        ),
      ),
      
      // Only Send button needs Obx (for isSending loading state)
      Obx(() => ElevatedButton(
        onPressed: controller.isSending.value ? null : () => send(),
        child: controller.isSending.value
            ? CircularProgressIndicator()
            : Text("Send"),
      )),
    ],
  );
}
```

**Benefits:**
- ✅ TextField only created once
- ✅ Minimal rebuilds (only Send button updates)
- ✅ Better performance
- ✅ Follows GetX best practices

---

## Pattern 5: Error Handling with dartz Either

### Before (No Error Handling)
```dart
// ❌ Can crash on network error
void sendMessage(String text) async {
  final messages = await _repository.sendMessage(text);
  // What if network fails? App crashes!
}
```

### After (Proper Error Handling)
```dart
// ✅ Graceful error handling
void sendMessage(String message) async {
  if (message.trim().isEmpty) return;

  isSending.value = true;

  final result = await _repository.sendMessage(
    chatId: chatId,
    message: message.trim(),
  );

  // Either<Failure, List<MessageModel>>
  result.fold(
    // Left: Failure case
    (failure) {
      Get.snackbar(
        "Error",
        failure.message ?? "Failed to send message",
        backgroundColor: Colors.red,
      );
    },
    // Right: Success case
    (data) {
      messages.assignAll(data);
      _cacheMessages();
      messageInput.value = '';
      _scrollToBottom();
    },
  );

  isSending.value = false;
}
```

**Benefits:**
- ✅ Network errors handled gracefully
- ✅ User sees meaningful error message
- ✅ App never crashes
- ✅ Clear error/success paths

---

## Pattern 6: Reactive Navigation with Parameters

### Before (Navigation Issue)
```dart
// ❌ Doesn't pass chatId
onTap: () => Get.to(() => ChatDetailScreen(
  name: chat.name,
  // chatId is missing!
)),
```

### After (Correct Navigation)
```dart
// ✅ Passes all necessary parameters
onTap: () => Get.to(() => ChatDetailScreen(
  name: chat.name,
  chatId: chat.id,  // ← Controller uses this in init()
)),
```

**In StatefulWidget:**
```dart
@override
void initState() {
  super.initState();
  controller.init(widget.chatId);  // ← Uses navigation parameter
}
```

**Benefits:**
- ✅ Each chat loads its own messages
- ✅ Clean data flow from navigation to controller
- ✅ Easy to debug (parameter passing clear)

---

## Pattern 7: Detecting Message Owner (Sent vs Received)

```dart
// In chat_detail_screen.dart
bool isMe = controller.currentUserId == msg.user.id;

return MessageBubble(
  message: msg,
  isMe: isMe,  // ← Determines bubble color
);

// In message_bubble.dart
@override
Widget build(BuildContext context) {
  final bgColor = widget.isMe
      ? Color(0xFFFFF0F2)  // Soft pink for sent
      : Color(0xFFF1F2F4);  // Grey for received

  final alignment = widget.isMe
      ? Alignment.centerRight
      : Alignment.centerLeft;

  return Align(
    alignment: alignment,
    child: Container(
      color: bgColor,
      child: Text(widget.message.text),
    ),
  );
}
```

**Benefits:**
- ✅ Clear visual distinction between sent/received
- ✅ Proper message ownership detection
- ✅ Safe comparison with current user ID

---

## Pattern 8: Auto-Scroll to Latest Message

```dart
// In message_controller.dart
final ScrollController scrollController = ScrollController();

void _scrollToBottom() {
  // Delay to ensure ListView is built
  Future.delayed(const Duration(milliseconds: 300), () {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  });
}

// Call after new messages
void loadMessages() async {
  // ... load messages ...
  _scrollToBottom();  // ← Auto-scroll to bottom
}

void sendMessage() async {
  // ... send message ...
  _scrollToBottom();  // ← Auto-scroll to new message
}

// In chat_detail_screen.dart
ListView.builder(
  controller: scrollController,  // ← Attach controller
  itemCount: controller.messages.length,
  itemBuilder: (_, index) => MessageBubble(controller.messages[index]),
)
```

**Benefits:**
- ✅ Automatically shows latest messages
- ✅ Smooth scroll animation
- ✅ Better UX
- ✅ Safe hasClients check prevents errors

---

## Complete Feature Checklist

When adding new chat features, follow these patterns:

- [ ] Models have complete `toJson()` and `fromJson()` with safe defaults
- [ ] Cache logic: load from storage → display → API refresh
- [ ] StatefulWidget lifecycle for persistent controllers
- [ ] TextEditingController created in `initState()`, disposed in `dispose()`
- [ ] Only reactive elements wrapped in `Obx()`
- [ ] Error handling with Either and snackbars
- [ ] Navigation passes all necessary parameters
- [ ] Message ownership detected via `currentUserId` comparison
- [ ] Auto-scroll to latest messages
- [ ] Proper GetStorage initialization in app startup

Use these patterns as template for consistency across the chat feature!
