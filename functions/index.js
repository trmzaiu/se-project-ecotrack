const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document("notifications/{notificationId}")
    .onCreate(async (snap, context) => {
      const data = snap.data();

      if (!data || !data.token || !data.title || !data.body || !data.userId) {
        console.log("Missing required fields");
        return;
      }

      const message = {
        token: data.token,
        notification: {
          title: data.title,
          body: data.body,
        },
        data: {
          notificationId: context.params.notificationId,
          type: data.type || "",
          userId: data.userId,
          time: data.time ? data.time.toDate().toISOString() : "",
          isRead: data.isRead ? data.isRead.toString() : "false",
        },
      };

      try {
        await admin.messaging().send(message);
        console.log("Notification sent to:", data.token);
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });
