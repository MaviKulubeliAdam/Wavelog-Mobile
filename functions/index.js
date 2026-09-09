const functions = require("firebase-functions/v1");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

const db = getFirestore();
const messaging = getMessaging();

// ── 1. Yeni aktivasyon paylaşılınca genel bildirim ───────────────────────────
exports.onNewActivation = functions
  .firestore.document("planned_activations/{docId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    if (!data) return;

    const typeLabel =
      data.type === "sota" ? "SOTA" :
      data.type === "pota" ? "POTA" : "Genel";

    const bands = (data.bands ?? []).join(", ") || "?";
    const modes = (data.modes ?? []).join(", ") || "?";

    await messaging.send({
      topic: "new_activations",
      notification: {
        title: `${data.callsign} aktivasyon duyurdu`,
        body: `${typeLabel} - ${bands} - ${modes}`,
      },
      data: {
        activationId: context.params.docId,
        callsign: data.callsign ?? "",
        type: data.type ?? "general",
        screen: "community",
      },
      android: { notification: { channelId: "activations" } },
      apns: { payload: { aps: { sound: "default" } } },
    });
  });

// ── 2. Yaklaşan aktivasyonlar için hatırlatma (her 15 dk) ────────────────────
exports.notifyUpcomingActivations = functions
  .pubsub.schedule("every 15 minutes")
  .timeZone("UTC")
  .onRun(async () => {
    const admin = require("firebase-admin");
    const now = admin.firestore.Timestamp.now();
    const in15 = admin.firestore.Timestamp.fromMillis(now.toMillis() + 15 * 60 * 1000);
    const in45 = admin.firestore.Timestamp.fromMillis(now.toMillis() + 45 * 60 * 1000);

    const snapshot = await db
      .collection("planned_activations")
      .where("scheduledAt", ">=", in15)
      .where("scheduledAt", "<=", in45)
      .where("notified", "==", false)
      .get();

    if (snapshot.empty) return;

    const sends = snapshot.docs.map(async (doc) => {
      const data = doc.data();
      const typeLabel =
        data.type === "sota" ? "SOTA" :
        data.type === "pota" ? "POTA" : "Genel";

      const bands = (data.bands ?? []).join(", ") || "?";
      const minutesLeft = Math.round(
        (data.scheduledAt.toMillis() - now.toMillis()) / 60000
      );

      await messaging.send({
        topic: `activation_${doc.id}`,
        notification: {
          title: `${data.callsign} ${minutesLeft} dk icinde basliyor`,
          body: `${typeLabel} - ${bands}`,
        },
        data: {
          activationId: doc.id,
          callsign: data.callsign ?? "",
          type: data.type ?? "general",
          screen: "community",
        },
        android: { notification: { channelId: "activations" }, priority: "high" },
        apns: { payload: { aps: { sound: "default" } } },
      });

      await doc.ref.update({ notified: true });
    });

    await Promise.allSettled(sends);
  });
