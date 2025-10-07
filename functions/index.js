const functions = require("firebase-functions");
const Stripe = require("stripe");

// استخدام المفتاح من متغيرات البيئة لحماية البيانات الحساسة
const stripe = new Stripe(functions.config().stripe.secret_key);

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  // التحقق من أن المستخدم مسجل دخول
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated to create payment intent",
    );
  }

  const {amount, currency} = data;

  // التحقق من صحة البيانات المدخلة
  if (!amount || amount <= 0) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Amount must be a positive number",
    );
  }

  if (!currency || typeof currency !== "string") {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Currency must be a valid string",
    );
  }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount), // التأكد من أن المبلغ عدد صحيح
      currency: currency.toLowerCase(),
      payment_method_types: ["card"],
      metadata: {
        userId: context.auth.uid,
        timestamp: new Date().toISOString(),
      },
    });

    return {
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
    };
  } catch (error) {
    console.error("Error creating payment intent:", error);
    throw new functions.https.HttpsError(
        "internal",
        `Failed to create payment intent: ${error.message}`,
    );
  }
});
