const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// تعديل المسار هنا لو في path مختلف عندك
// مثال شائع: chatRooms/{chatRoomId}/messages/{msgId}
exports.sendChatNotification = functions.firestore
  .document("chatRooms/{chatRoomId}/messages/{msgId}")
  .onCreate(async (snapshot, context) => {
    try {
      const messageData = snapshot.data();
      if (!messageData) return null;

      const chatRoomId = context.params.chatRoomId;
      const senderId = messageData.senderId || "";
      let receiverId = messageData.receiverId; // الأفضل لو انت بتضيفه عند ارسال الرسالة

      // لو مفيش receiverId لما الرسالة تتخزن، نقرأ chatRoom metadata ونجيب باقي المشاركين
      if (!receiverId) {
        const roomDoc = await admin.firestore().collection("chatRooms").doc(chatRoomId).get();
        if (roomDoc.exists) {
          const roomData = roomDoc.data() || {};
          const participants = roomData.participants || []; // مفترض array of uids
          // اخد أول UID مختلف عن ال sender كـ receiver
          receiverId = participants.find((id) => id !== senderId);
        }
      }

      if (!receiverId) {
        console.log("No receiverId found for message:", snapshot.id);
        return null;
      }

      // مكان تخزين الـ tokens — عدل لو انت بتخزنهم في مكان تاني (مثلاً 'Users' أو 'users' أو 'Student')
      const userDoc = await admin.firestore().collection("Student").doc(receiverId).get();
      if (!userDoc.exists) {
        console.log("Receiver user doc not found:", receiverId);
        return null;
      }

      const userData = userDoc.data() || {};
      // افترض أنك تخزن fcmToken أو fcmTokens (لأكثر من جهاز)
      let tokens = [];

      if (Array.isArray(userData.fcmTokens) && userData.fcmTokens.length > 0) {
        tokens = userData.fcmTokens;
      } else if (typeof userData.fcmToken === "string" && userData.fcmToken) {
        tokens = [userData.fcmToken];
      }

      if (tokens.length === 0) {
        console.log("No FCM tokens for user:", receiverId);
        return null;
      }

      // شكل الاشعار
      const title = messageData.title || "New message";
      const body = messageData.text || "You have a new message";

      const payload = {
        notification: {
          title,
          body,
        },
        data: {
          chatRoomId: chatRoomId,
          senderId: senderId,
          messageId: snapshot.id,
          click_action: "FLUTTER_NOTIFICATION_CLICK" // for flutter_local_notifications if used
        },
        android: {
          priority: "high",
          notification: {
            sound: "default",
            channel_id: "chat_messages"
          }
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
              contentAvailable: true,
            }
          }
        }
      };

      // استخدم sendMulticast لدعم عدة توكنز
      if (tokens.length === 1) {
        const res = await admin.messaging().sendToDevice(tokens[0], payload);
        console.log("Notification sent (single):", res);
      } else {
        const res = await admin.messaging().sendMulticast({
          tokens,
          ...payload
        });
        console.log("Notification sent (multicast):", res.successCount, "success,", res.failureCount, "failures");
        // احذف التوكنز الفاشلة (اختياري) لتحسين المستقبل
        if (res.failureCount > 0) {
          const errors = [];
          res.responses.forEach((resp, idx) => {
            if (!resp.success) {
              errors.push({ token: tokens[idx], error: resp.error && resp.error.toString() });
            }
          });
          console.log("Failed tokens:", errors);
          // هنا ممكن تعمل منطق لحذف التوكنس الغلطه من الـ Firestore لو تحب
        }
      }

      return null;
    } catch (err) {
      console.error("sendChatNotification error:", err);
      return null;
    }
  });
