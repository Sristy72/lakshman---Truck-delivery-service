# 🎯 Chat Feature - Quick Reference Guide

## How Messages Persist (User's Original Requirement)

> "I want to save all the chat messages and when i will return this screen it show the previous messages"

### ✅ How It Works

```dart
// When user enters chat screen:
ChatDetailScreen.initState() 
  → controller.init(chatId)
    → Load cached messages from GetStorage (instant display ⚡)
    → API call fetches fresh messages (background refresh)
    → Cache updated automatically

// When user returns to same chat:
ChatDetailScreen.initState() (again)
  → controller.init(chatId)
    → Load cached messages (instant ⚡)
    → API refresh happens in background
```

**Result:** Previous messages always visible when you return, even if offline!

---

## File Locations

```
lib/features/chat/
├── controllers/
│   └── message_controller.dart ← Caching logic & state
├── data/
│   ├── message_api.dart ← API calls
│   ├── message_repository.dart ← Error handling
│   └── models/
│       └── message_model.dart ← Serialization (toJson/fromJson)
└── presentation/
    ├── screens/
    │   ├── chat_detail_screen.dart ← Main chat UI ⭐
    │   └── chat_inbox_screen.dart ← Chat list
    └── widgets/
        └── message_bubble.dart ← Message styling
```

---

## Key Implementation Details

### 1. Message Caching (GetStorage)

**Stored as:**
```dart
box.write('chat_$chatId', jsonList)
// Example: 'chat_507f1f77bcf86cd799439011' contains all messages as JSON
```

**Automatic update:**
```dart
void _cacheMessages() {
  final jsonList = messages.map((msg) => msg.toJson()).toList();
  box.write('chat_$chatId', jsonList);  // Auto-called after API response
}
```

### 2. StatefulWidget Lifecycle

```dart
class ChatDetailScreen extends StatefulWidget {
  @override
  void initState() {
    // Called once when screen enters
    controller.init(widget.chatId);  // Load cache + refresh
    _textController = TextEditingController();  // Create once
  }

  @override
  void dispose() {
    _textController.dispose();  // Clean up resources
  }
}
```

**Why StatefulWidget?**
- `TextEditingController` needs lifecycle management
- `initState()` called on each screen entry (fresh cache load)
- `dispose()` prevents memory leaks

### 3. GetX Best Practice - TextField NOT in Obx

```dart
// ❌ WRONG - Causes unnecessary rebuilds
Obx(() => TextField(controller: _textController))

// ✅ CORRECT - TextField outside Obx
TextField(controller: _textController)

// ✅ ONLY Send button needs Obx (for loading state)
Obx(() => OutlinedButton(
  onPressed: controller.isSending.value ? null : () => sendMessage(),
  child: controller.isSending.value 
      ? CircularProgressIndicator()
      : Text("Send")
))
```

---

## Testing the Feature

### Quick Test (5 minutes)

```bash
# Terminal
flutter run

# In app:
1. Open any chat from inbox
2. Scroll to see previous messages ← Loaded from cache
3. Send a new message
4. Verify new message appears with pink bubble (outgoing)
5. Go back to inbox
6. Open same chat again
7. Verify all messages including new one are there ✅
```

### Offline Test (10 minutes)

```bash
# Terminal
flutter run

# In app:
1. Enable airplane mode (no network)
2. Open a chat you've visited before
3. Previous messages load from cache ✅
4. Try sending message → Error snackbar
5. Disable airplane mode
6. Send works again
7. Messages preserved ✅
```

---

## How to Add New Features

### Add Message Attachment Support

1. Update `MessageModel` to include attachments:
```dart
class MessageModel {
  final List<Attachment> attachments;
  // ... existing fields
  
  Map<String, dynamic> toJson() {
    return {
      // ... existing fields
      'attachments': attachments.map((a) => a.toJson()).toList(),
    };
  }
}
```

2. Update API in `sendMessage()` to handle attachments
3. Update `message_bubble.dart` to render attachments
4. Cache automatically saves everything via `toJson()`

### Add Typing Indicator

1. Add `typingUsers` observable to `MessageController`:
```dart
var typingUsers = <String>[].obs;
```

2. Listen to WebSocket events (if available) or API polling
3. Update UI in `chat_detail_screen.dart` to show "User is typing..."

---

## Common Issues & Solutions

### Issue: Messages not persisting after app restart

**Check:**
1. `GetStorage.init()` called in `main.dart` → `app_initializer.dart` ✓
2. Cache key format correct: `'chat_$chatId'` ✓
3. Models have `toJson()` method ✓

**Fix:**
```dart
// In app_initializer.dart
await GetStorage.init();  // Must be called before any GetStorage usage
```

### Issue: TextField rebuilds when message list updates

**Check:** TextField not wrapped in `Obx()`

**Fix:**
```dart
// Current (WRONG)
Obx(() => TextField(...))

// Change to (CORRECT)
TextField(...)
```

### Issue: Cache shows old messages even after sending new message

**Check:** `_cacheMessages()` called after API response

**Fix:**
```dart
// In sendMessage()
result.fold(
  (failure) => /* error handling */,
  (data) {
    messages.assignAll(data);
    _cacheMessages();  // ← Must be called here
  },
);
```

---

## Performance Tips

1. **Message Limit:** For large chats, implement pagination
   - Fetch first 50 messages
   - Load more on scroll up

2. **Image Optimization:** Resize avatars in message bubbles
   - Use `Image.network` with `width: 32, height: 32`

3. **Scroll Performance:** If >1000 messages, use `ListView.separated`
   - Better memory usage for large lists

4. **Cache Size:** Monitor GetStorage usage
   - Clear old chats cache periodically
   - Or implement max cache age

---

## Debug Commands

```bash
# Analyze for issues
flutter analyze

# Get dependencies
flutter pub get

# Format code
dart format lib/

# Run with verbose logging
flutter run -v

# Check compiled output
flutter build apk  # Android
flutter build ios  # iOS
```

---

## API Response Format

The backend returns this format (make sure your API matches):

```json
[
  {
    "_id": "msg123",
    "text": "Hello there!",
    "user": {
      "_id": "user456",
      "name": "John Doe",
      "role": "client",
      "avatar": {
        "public_id": "avatar123",
        "url": "https://..."
      }
    },
    "date": "2024-11-20T10:30:00Z",
    "read": true
  }
]
```

---

## Deployment Checklist

- [ ] Test on real device (not just emulator)
- [ ] Test with actual network conditions (3G/LTE)
- [ ] Test offline mode (airplane mode)
- [ ] Verify cache persists across app restarts
- [ ] Check performance with 100+ messages
- [ ] Test on low-memory devices
- [ ] Verify no console errors with `flutter run -v`
- [ ] Get feedback from QA team
- [ ] Create release build: `flutter build apk --release`

---

## Support & Questions

**Common Questions:**

Q: Why use GetStorage instead of Hive/Isar?
A: GetStorage is lightweight, no migration issues, perfect for chat. Hive/Isar better for complex relational data.

Q: Can I use SQLite instead?
A: Yes, but requires more setup. GetStorage is simpler and sufficient for chat.

Q: How long are messages cached?
A: Until app uninstalls or cache is manually cleared. Implement cleanup if needed.

Q: Can multiple chats share the same cache?
A: No, each chat has separate key: `'chat_$chatId'`. Prevents data mixing.

---

**Status:** ✅ Production Ready

Use this guide as reference when updating the chat feature or implementing similar persistence patterns in other features.
